import 'package:guda_chatbot/features/auth/domain/entities/guda_user.dart';
import 'package:guda_chatbot/features/auth/domain/repositories/auth_repository.dart';

/// 이메일/비밀번호 로그인 유즈케이스
class SignInWithEmailUseCase {
  const SignInWithEmailUseCase(this._repository);
  final AuthRepository _repository;

  Future<GudaUser> call(String email, String password) =>
      _repository.signInWithEmail(email, password);
}

/// 이메일/비밀번호 회원가입 유즈케이스
class SignUpWithEmailUseCase {
  const SignUpWithEmailUseCase(this._repository);
  final AuthRepository _repository;

  Future<GudaUser> call(String email, String password) =>
      _repository.signUpWithEmail(email, password);
}

/// Google 소셜 로그인 유즈케이스
class SignInWithGoogleUseCase {
  const SignInWithGoogleUseCase(this._repository);
  final AuthRepository _repository;

  /// Google 로그인 실행
  Future<GudaUser> call() => _repository.signInWithGoogle();
}

/// Apple 소셜 로그인 유즈케이스
class SignInWithAppleUseCase {
  const SignInWithAppleUseCase(this._repository);
  final AuthRepository _repository;

  /// Apple 로그인 실행
  Future<GudaUser> call() => _repository.signInWithApple();
}

/// 로그아웃 유즈케이스
class SignOutUseCase {
  const SignOutUseCase(this._repository);
  final AuthRepository _repository;

  /// 로그아웃 실행
  Future<void> call() => _repository.signOut();
}

/// 계정 탈퇴 유즈케이스
class DeleteAccountUseCase {
  const DeleteAccountUseCase(this._repository);
  final AuthRepository _repository;

  /// 계정 탈퇴 실행
  Future<void> call() => _repository.deleteAccount();
}

/// 현재 사용자 조회 유즈케이스
class GetCurrentUserUseCase {
  const GetCurrentUserUseCase(this._repository);
  final AuthRepository _repository;

  /// 현재 로그인된 사용자 반환 (미인증 시 null)
  Future<GudaUser?> call() => _repository.getCurrentUser();
}
