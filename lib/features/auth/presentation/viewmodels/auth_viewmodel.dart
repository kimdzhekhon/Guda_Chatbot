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
SignInWithGoogleUseCase signInWithGoogleUseCase(Ref ref) =>
    SignInWithGoogleUseCase(ref.watch(authRepositoryProvider));

@riverpod
SignInWithAppleUseCase signInWithAppleUseCase(Ref ref) =>
    SignInWithAppleUseCase(ref.watch(authRepositoryProvider));

@riverpod
SignOutUseCase signOutUseCase(Ref ref) =>
    SignOutUseCase(ref.watch(authRepositoryProvider));

@riverpod
DeleteAccountUseCase deleteAccountUseCase(Ref ref) =>
    DeleteAccountUseCase(ref.watch(authRepositoryProvider));

@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) =>
    GetCurrentUserUseCase(ref.watch(authRepositoryProvider));

/// Auth ViewModel — Google 로그인/로그아웃 및 인증 상태 관리
@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  UiState<GudaUser?> build() {
    return const UiLoading(); // 앱 초기화 시 스플래시 화면을 띄우기 위해 로딩 상태 반환
  }

  /// 초기 세션 복원 — SplashScreen에서 호출
  Future<void> checkSession() async {
    // Auth 화면 흐름을 점검하기 위해 미인증 처리 (스플래시를 감상할 수 있게 1.5초 대기)
    await Future.delayed(const Duration(milliseconds: 1500));
    state = const UiSuccess(null);
  }

  /// Google 로그인 실행 (Mock)
  Future<void> signInWithGoogle() async {
    state = const UiLoading();

    // 임시: 실제 서버 통신 없이 바로 가짜 유저 생성 후 인증 성공 처리
    await Future.delayed(const Duration(milliseconds: 800));

    final mockUser = GudaUser(
      id: 'mock-1234',
      email: 'guest@guda.chat',
      displayName: 'Guda 게스트',
      createdAt: DateTime.now(),
    );

    state = UiSuccess(mockUser);
  }

  /// Apple 로그인 실행 (Mock)
  Future<void> signInWithApple() async {
    state = const UiLoading();

    // 임시: 실제 서버 통신 없이 바로 가짜 유저 생성 후 인증 성공 처리
    await Future.delayed(const Duration(milliseconds: 800));

    final mockUser = GudaUser(
      id: 'mock-apple-1234',
      email: 'apple-guest@guda.chat',
      displayName: 'Apple 게스트',
      createdAt: DateTime.now(),
    );

    state = UiSuccess(mockUser);
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

  /// 계정 탈퇴
  Future<void> deleteAccount() async {
    state = const UiLoading();
    try {
      await ref.read(deleteAccountUseCaseProvider).call();
      state = const UiSuccess(null);
    } catch (e) {
      state = UiError('계정 탈퇴 중 오류가 발생했습니다: ${e.toString()}');
    }
  }
}
