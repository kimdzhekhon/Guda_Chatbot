import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/features/auth/data/datasources/supabase_auth_datasource.dart';
import 'package:guda_chatbot/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:guda_chatbot/features/auth/domain/entities/guda_user.dart';
import 'package:guda_chatbot/features/auth/domain/usecases/auth_usecases.dart';

part 'auth_viewmodel.g.dart';

/// Auth 관련 Provider 의존성
@riverpod
SupabaseAuthDataSource supabaseAuthDataSource(Ref ref) =>
    SupabaseAuthDataSource();

@riverpod
AuthRepositoryImpl authRepository(Ref ref) =>
    AuthRepositoryImpl(ref.watch(supabaseAuthDataSourceProvider));

@riverpod
SignInWithEmailUseCase signInWithEmailUseCase(Ref ref) =>
    SignInWithEmailUseCase(ref.watch(authRepositoryProvider));

@riverpod
SignUpWithEmailUseCase signUpWithEmailUseCase(Ref ref) =>
    SignUpWithEmailUseCase(ref.watch(authRepositoryProvider));

@riverpod
SignInWithGoogleUseCase signInWithGoogleUseCase(Ref ref) =>
    SignInWithGoogleUseCase(ref.watch(authRepositoryProvider));

@riverpod
SignInWithAppleUseCase signInWithAppleUseCase(Ref ref) =>
    SignInWithAppleUseCase(ref.watch(authRepositoryProvider));

@riverpod
SignOutUseCase signOutUseCase(Ref ref) =>
    SignOutUseCase(ref.watch(authRepositoryProvider));

@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) =>
    GetCurrentUserUseCase(ref.watch(authRepositoryProvider));

/// Auth ViewModel — 이메일/Google/Apple 로그인 및 인증 상태 관리
@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  UiState<GudaUser?> build() {
    return const UiLoading();
  }

  /// 초기 세션 복원 — SplashScreen에서 호출
  Future<void> checkSession() async {
    try {
      final user = await ref.read(getCurrentUserUseCaseProvider).call();
      state = UiSuccess(user);
    } catch (e) {
      state = const UiSuccess(null);
    }
  }

  /// 이메일/비밀번호 로그인
  Future<void> signInWithEmail(String email, String password) async {
    state = const UiLoading();
    try {
      final user = await ref.read(signInWithEmailUseCaseProvider).call(email, password);
      state = UiSuccess(user);
    } catch (e) {
      final message = e.toString().contains('Invalid login credentials')
          ? '이메일 또는 비밀번호가 틀렸습니다'
          : '로그인 중 오류가 발생했습니다';
      state = UiError(message);
    }
  }

  /// 이메일/비밀번호 회원가입
  Future<void> signUpWithEmail(String email, String password) async {
    state = const UiLoading();
    try {
      final user = await ref.read(signUpWithEmailUseCaseProvider).call(email, password);
      state = UiSuccess(user);
    } catch (e) {
      final msg = e.toString();
      final message = msg.contains('already registered')
          ? '이미 가입된 이메일입니다'
          : msg.contains('Password should be at least')
              ? '비밀번호는 6자 이상이어야 합니다'
              : '회원가입 중 오류가 발생했습니다';
      state = UiError(message);
    }
  }

  /// Google 로그인
  Future<void> signInWithGoogle() async {
    state = const UiLoading();
    try {
      final user = await ref.read(signInWithGoogleUseCaseProvider).call();
      state = UiSuccess(user);
    } catch (e) {
      state = UiError('Google 로그인에 실패했습니다: ${e.toString()}');
    }
  }

  /// Apple 로그인
  Future<void> signInWithApple() async {
    state = const UiLoading();
    try {
      final user = await ref.read(signInWithAppleUseCaseProvider).call();
      state = UiSuccess(user);
    } catch (e) {
      state = UiError('Apple 로그인에 실패했습니다: ${e.toString()}');
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    state = const UiLoading();
    try {
      await ref.read(signOutUseCaseProvider).call();
      state = const UiSuccess(null);
    } catch (e) {
      state = UiError('로그아웃 중 오류가 발생했습니다: ${e.toString()}');
    }
  }
}
