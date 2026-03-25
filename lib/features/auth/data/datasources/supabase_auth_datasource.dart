import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:guda_chatbot/features/auth/data/models/auth_response_dto.dart';

/// Supabase 인증 데이터 소스 — Google OAuth 연동
class SupabaseAuthDataSource {
  SupabaseAuthDataSource()
    : _supabase = Supabase.instance.client,
      _googleSignIn = GoogleSignIn();

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

  /// 이메일/비밀번호 로그인
  Future<AuthResponseDto> signInWithEmail(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) throw const AuthException('로그인에 실패했습니다.');
    return _mapSupabaseUserToDto(user);
  }

  /// 이메일/비밀번호 회원가입
  Future<AuthResponseDto> signUpWithEmail(String email, String password) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) throw const AuthException('회원가입에 실패했습니다.');
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
}
