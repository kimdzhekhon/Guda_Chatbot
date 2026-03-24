import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:guda_chatbot/features/auth/data/models/auth_response_dto.dart';
import 'package:guda_chatbot/features/auth/domain/entities/guda_user.dart';

/// Supabase 인증 데이터 소스 — Google OAuth 연동
class SupabaseAuthDataSource {
  SupabaseAuthDataSource()
    : _supabase = Supabase.instance.client,
      _googleSignIn = GoogleSignIn();

  final SupabaseClient _supabase;
  final GoogleSignIn _googleSignIn;

  /// Google 계정으로 Supabase 인증
  Future<GudaUser> signInWithGoogle() async {
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

    return _mapSupabaseUserToEntity(user);
  }

  /// Apple 계정으로 Supabase 인증 (Placeholder)
  Future<GudaUser> signInWithApple() async {
    // TODO: Apple 로그인 SDK 연동 필요
    throw const AuthException('Apple 로그인은 현재 준비 중입니다.');
  }

  /// 로그아웃
  Future<void> signOut() async {
    await Future.wait([_supabase.auth.signOut(), _googleSignIn.signOut()]);
  }

  /// 현재 세션에서 사용자 조회
  Future<GudaUser?> getCurrentUser() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    return _mapSupabaseUserToEntity(user);
  }

  /// 인증 상태 스트림
  Stream<GudaUser?> authStateChanges() {
    return _supabase.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      if (user == null) return null;
      return _mapSupabaseUserToEntity(user);
    });
  }

  /// Supabase User → GudaUser 도메인 엔티티 변환
  GudaUser _mapSupabaseUserToEntity(User user) {
    final json = {
      'id': user.id,
      'email': user.email,
      ...user.userMetadata ?? {},
      'created_at': user.createdAt,
    };
    return AuthResponseDto.fromJson(json).toDomain();
  }
}
