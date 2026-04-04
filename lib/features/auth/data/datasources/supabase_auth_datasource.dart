import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:guda_chatbot/features/auth/data/models/auth_response_dto.dart';
import 'package:guda_chatbot/features/auth/data/models/profile_registration_dto.dart';
import 'package:guda_chatbot/features/auth/data/models/persona_update_dto.dart';
import 'package:guda_chatbot/app/config/app_config.dart';

/// Supabase 인증 데이터 소스 — Google OAuth 연동
class SupabaseAuthDataSource {
  SupabaseAuthDataSource()
    : _supabase = Supabase.instance.client,
      _googleSignIn = GoogleSignIn(
        clientId: Platform.isIOS ? AppConfig.googleIosClientId : null,
        serverClientId: Platform.isAndroid && AppConfig.googleWebClientId.isNotEmpty
            ? AppConfig.googleWebClientId
            : null,
      );

  final SupabaseClient _supabase;
  final GoogleSignIn _googleSignIn;

  /// Google 계정으로 Supabase 인증
  Future<AuthResponseDto> signInWithGoogle() async {
    // 1. Google 로그인 팝업
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw const AuthException('Google 로그인이 취소되었습니다.');
    }

    // 2. Google 인증 토큰 획득
    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;

    if (idToken == null || accessToken == null) {
      throw const AuthException('Google 인증 토큰을 가져올 수 없습니다.');
    }

    // 3. Supabase OAuth 로그인
    final response = await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    final user = response.user;
    if (user == null) throw const AuthException('Supabase 인증에 실패했습니다.');

    // 4. 탈퇴 확인 + 프로필 조회를 병렬로 수행 (로그인 속도 개선)
    final results = await Future.wait([
      _checkDeletedAccount(user.email ?? ''),
      getProfile(user.id),
    ]);

    // 5. 프로필 정보 병합
    final profile = results[1] as Map<String, dynamic>?;
    return _mapSupabaseUserToDto(user, profile: profile);
  }

  /// Apple 계정으로 Supabase 인증 (Placeholder)
  Future<AuthResponseDto> signInWithApple() async {
    // TODO: Apple 로그인 SDK 연동 필요
    throw const AuthException('Apple 로그인은 현재 준비 중입니다.');
  }

  /// 로그아웃
  Future<void> signOut() async {
    await Future.wait([_supabase.auth.signOut(), _googleSignIn.signOut()]);
  }

  /// 현재 세션에서 사용자 조회
  Future<AuthResponseDto?> getCurrentUser() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    
    // 세션 복원 시 프로필 정보도 함께 가져옴
    final profile = await getProfile(user.id);
    return _mapSupabaseUserToDto(user, profile: profile);
  }

  /// 계정 탈퇴 — Edge Function으로 auth.users까지 완전 삭제 후 로그아웃
  Future<void> deleteAccount() async {
    // 세션 갱신 후 최신 토큰 사용
    try {
      await _supabase.auth.refreshSession();
    } catch (_) {}

    final session = _supabase.auth.currentSession;
    if (session == null) throw const AuthException('로그인 세션이 없습니다.');

    try {
      await Dio().post(
        '${AppConfig.supabaseUrl}/functions/v1/delete-account',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${session.accessToken}',
            'apikey': AppConfig.supabaseAnonKey,
          },
        ),
      );
    } on DioException catch (e) {
      final body = e.response?.data;
      final errorMsg = body is Map
          ? (body['error'] ?? body['msg'] ?? body['message'] ?? '계정 삭제에 실패했습니다.')
          : '계정 삭제에 실패했습니다.';
      throw AuthException(errorMsg.toString());
    }

    await signOut();
  }

  /// 인증 상태 스트림
  Stream<AuthResponseDto?> authStateChanges() {
    return _supabase.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      if (user == null) return null;
      return _mapSupabaseUserToDto(user);
    });
  }

  /// Supabase User → AuthResponseDto 변환
  AuthResponseDto _mapSupabaseUserToDto(User user, {Map<String, dynamic>? profile}) {
    final json = {
      'id': user.id,
      'email': user.email,
      ...user.userMetadata ?? {},
      'created_at': user.createdAt,
    };

    // profile의 null 값은 Auth 데이터를 덮어쓰지 않도록 제거 후 병합
    if (profile != null) {
      final filtered = Map<String, dynamic>.from(profile)
        ..removeWhere((_, v) => v == null);
      json.addAll(filtered);
    }

    return AuthResponseDto.fromJson(json);
  }

  /// 프로필 테이블 데이터 업데이트 (RPC 연동)
  Future<void> updateProfile(ProfileRegistrationDto dto) async {
    try {
      await _supabase.rpc('upsert_profile', params: dto.toJson());
    } catch (e) {
      debugPrint('[AuthDS] upsert_profile 에러: $e');
      rethrow;
    }
  }

  /// 페르소나 단일 업데이트 (RPC 연동)
  Future<void> updatePersona(PersonaUpdateDto dto) async {
    await _supabase.rpc('update_persona', params: dto.toJson());
  }

  /// 탈퇴 후 30일 재가입 차단 확인
  Future<void> _checkDeletedAccount(String email) async {
    if (email.isEmpty) return;
    try {
      final List<dynamic> result = await _supabase.rpc(
        'check_deleted_account',
        params: {'check_email': email},
      );
      if (result.isNotEmpty && result.first['is_blocked'] == true) {
        final days = result.first['remaining_days'] as int;
        // 차단 대상이면 즉시 로그아웃하고 에러
        await signOut();
        throw AuthException('탈퇴 후 30일간 재가입이 불가합니다. ($days일 남음)');
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      // RPC 실패 시 차단하지 않음 (테이블 미생성 등)
      debugPrint('[AuthDS] check_deleted_account 에러: $e');
    }
  }

  /// profiles 테이블에서 추가 정보 조회 (RPC 전환으로 아키텍처 준수)
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    // 직접 테이블 조회를 RPC 호출로 대체 (안티 그래비티 아키텍처 규칙 준수)
    final List<dynamic> result = await _supabase.rpc('get_my_profile');
    
    if (result.isEmpty) return null;
    return result.first as Map<String, dynamic>;
  }
}
