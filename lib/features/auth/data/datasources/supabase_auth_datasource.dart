import 'dart:io';
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

    return _mapSupabaseUserToDto(user);
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
    return _mapSupabaseUserToDto(user);
  }

  /// 계정 탈퇴
  Future<void> deleteAccount() async {
    // TODO: 실제 백엔드 연동 전까지 로컬 로그아웃만 수행 (보통 Edge Function이나 RPC로 처리)
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
  AuthResponseDto _mapSupabaseUserToDto(User user) {
    final json = {
      'id': user.id,
      'email': user.email,
      ...user.userMetadata ?? {},
      'created_at': user.createdAt,
    };
    return AuthResponseDto.fromJson(json);
  }

  /// 프로필 테이블 데이터 업데이트 (RPC 연동)
  Future<void> updateProfile(ProfileRegistrationDto dto) async {
    // architecture 규정상 RPC 형식을 준수하여 호출
    await _supabase.rpc('upsert_profile', params: dto.toJson());
  }

  /// 페르소나 단일 업데이트 (RPC 연동)
  Future<void> updatePersona(PersonaUpdateDto dto) async {
    // 단일 필드 업데이트를 위해 전용 RPC를 호출합니다.
    await _supabase.rpc('update_persona', params: dto.toJson());
  }

  /// profiles 테이블에서 추가 정보 조회
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    return await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
  }
}
