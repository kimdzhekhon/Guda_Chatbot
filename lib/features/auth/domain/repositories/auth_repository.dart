import 'package:guda_chatbot/features/auth/domain/entities/guda_user.dart';

/// Auth 리포지토리 추상 인터페이스 — 도메인 레이어
/// 구현체는 data 레이어에 위치
abstract interface class AuthRepository {
  /// 이메일/비밀번호 로그인
  Future<GudaUser> signInWithEmail(String email, String password);

  /// 이메일/비밀번호 회원가입
  Future<GudaUser> signUpWithEmail(String email, String password);

  /// Google 소셜 로그인
  Future<GudaUser> signInWithGoogle();

  /// Apple 소셜 로그인
  Future<GudaUser> signInWithApple();

  /// 로그아웃
  Future<void> signOut();

  /// 현재 로그인된 사용자 조회 (null이면 미인증)
  Future<GudaUser?> getCurrentUser();

  /// 인증 상태 스트림 (세션 변경 시 자동 갱신)
  Stream<GudaUser?> authStateChanges();
}
