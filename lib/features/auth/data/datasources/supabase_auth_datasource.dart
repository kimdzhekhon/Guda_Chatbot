import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
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

    // 4. 프로필 정보 조회 및 병합
    final profile = await getProfile(user.id);
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
    debugPrint('[DeleteAccount] accessToken 앞 20자: ${session.accessToken.substring(0, 20)}...');

    final response = await http.post(
      Uri.parse('${AppConfig.supabaseUrl}/functions/v1/delete-account'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${session.accessToken}',
        'apikey': AppConfig.supabaseAnonKey,
      },
    );

    if (response.statusCode != 200) {
      debugPrint('[DeleteAccount] Raw response (${response.statusCode}): ${response.body}');
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final errorMsg = body['error'] ?? body['msg'] ?? body['message'] ?? '계정 삭제에 실패했습니다.';
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
    final params = dto.toJson();
    debugPrint('[AuthDS] upsert_profile 호출: $params');
    try {
      final result = await _supabase.rpc('upsert_profile', params: params);
      debugPrint('[AuthDS] upsert_profile 결과: $result');
    } catch (e) {
      debugPrint('[AuthDS] upsert_profile 에러: $e');
      rethrow;
    }
  }

  /// 페르소나 단일 업데이트 (RPC 연동)
  Future<void> updatePersona(PersonaUpdateDto dto) async {
    await _supabase.rpc('update_persona', params: dto.toJson());
  }

  /// profiles 테이블에서 추가 정보 조회
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    debugPrint('[AuthDS] getProfile 호출: userId=$userId');
    final result = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    debugPrint('[AuthDS] getProfile 결과: $result');
    return result;
  }
}
