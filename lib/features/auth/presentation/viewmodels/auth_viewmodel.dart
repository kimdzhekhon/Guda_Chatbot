import 'dart:developer';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/features/auth/data/datasources/supabase_auth_datasource.dart';
import 'package:guda_chatbot/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:guda_chatbot/features/auth/domain/entities/guda_user.dart';
import 'package:guda_chatbot/features/auth/domain/usecases/auth_usecases.dart';
import 'package:guda_chatbot/features/chat/domain/entities/persona_type.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';

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

@riverpod
UpdateProfileUseCase updateProfileUseCase(Ref ref) =>
    UpdateProfileUseCase(ref.watch(authRepositoryProvider));

@riverpod
UpdatePersonaUseCase updatePersonaUseCase(Ref ref) =>
    UpdatePersonaUseCase(ref.watch(authRepositoryProvider));

/// Auth ViewModel — Google/Apple 로그인 및 인증 상태 관리
@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  UiState<GudaUser?> build() {
    return const UiLoading();
  }

  /// 초기 세션 복원 — SplashScreen에서 호출
  /// 세션은 있지만 프로필이 삭제된 유저(탈퇴 후 잔여 세션)는 강제 로그아웃 처리
  Future<void> checkSession() async {
    try {
      log('checkSession: 세션 확인 시작', name: 'AuthViewModel');
      final user = await ref.read(getCurrentUserUseCaseProvider).call();
      log('checkSession: user=${user?.id}, isProfileComplete=${user?.isProfileComplete}', name: 'AuthViewModel');

      if (user != null && !user.isProfileComplete) {
        log('checkSession: 프로필 미완성 → 강제 로그아웃', name: 'AuthViewModel');
        await ref.read(signOutUseCaseProvider).call();
        log('checkSession: 강제 로그아웃 완료', name: 'AuthViewModel');
        state = const UiSuccess(null);
        return;
      }

      state = UiSuccess(user);
    } catch (e, st) {
      log('checkSession 오류: $e', stackTrace: st, name: 'AuthViewModel');
      state = const UiSuccess(null);
    }
  }

  /// Google 로그인
  Future<void> signInWithGoogle() async {
    state = const UiLoading();
    try {
      final user = await ref.read(signInWithGoogleUseCaseProvider).call();
      state = UiSuccess(user);
    } catch (e) {
      state = UiError('${AppStrings.googleSignInError}: ${e.toString()}');
    }
  }

  /// Apple 로그인
  Future<void> signInWithApple() async {
    state = const UiLoading();
    try {
      final user = await ref.read(signInWithAppleUseCaseProvider).call();
      state = UiSuccess(user);
    } catch (e) {
      state = UiError('${AppStrings.appleSignInError}: ${e.toString()}');
    }
  }

  /// 프로필 정보 업데이트 (온보딩 최종 단계)
  Future<void> updateProfile({
    required PersonaType persona,
    required bool termsAgreed,
  }) async {
    state = const UiLoading();
    try {
      log('[updateProfile] 시작: persona=$persona', name: 'AuthViewModel');
      await ref.read(updateProfileUseCaseProvider).call(
        persona: persona,
        termsAgreed: termsAgreed,
      );
      log('[updateProfile] RPC 성공, 유저 재조회 시작', name: 'AuthViewModel');

      // 업데이트된 정보를 반영하기 위해 유저 정보 재조회
      final updatedUser = await ref.read(getCurrentUserUseCaseProvider).call();
      log('[updateProfile] 유저 재조회 완료: id=${updatedUser?.id}, persona=${updatedUser?.persona}, termsAgreed=${updatedUser?.termsAgreed}, isProfileComplete=${updatedUser?.isProfileComplete}', name: 'AuthViewModel');
      state = UiSuccess(updatedUser);
    } catch (e, st) {
      log('[updateProfile] 실패: $e', stackTrace: st, name: 'AuthViewModel');
      state = UiError('${AppStrings.profileUpdateError}: ${e.toString()}');
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    state = const UiLoading();
    try {
      await ref.read(signOutUseCaseProvider).call();
      state = const UiSuccess(null);
    } catch (e) {
      state = UiError('${AppStrings.logoutError}: ${e.toString()}');
    }
  }

  /// 계정 탈퇴
  Future<void> deleteAccount() async {
    final previousState = state;
    try {
      await ref.read(deleteAccountUseCaseProvider).call();
      state = const UiSuccess(null);
    } catch (e) {
      state = previousState;
    }
  }

  /// 페르소나 업데이트 (설정 화면)
  /// 실패해도 기존 인증 상태를 유지하여 라우터 리다이렉트를 방지합니다.
  Future<void> updatePersona(PersonaType persona) async {
    final previousState = state;
    try {
      await ref.read(updatePersonaUseCaseProvider).call(persona);

      // 업데이트된 정보를 반영하기 위해 유저 정보 재조회하여 상태 갱신
      final updatedUser = await ref.read(getCurrentUserUseCaseProvider).call();
      state = UiSuccess(updatedUser);
    } catch (e, st) {
      log('페르소나 업데이트 실패: $e', stackTrace: st, name: 'AuthViewModel');
      // 페르소나 변경 실패 시 이전 인증 상태를 복원합니다.
      // UiError로 설정하면 라우터가 로그인 화면으로 리다이렉트하기 때문입니다.
      state = previousState;
    }
  }
}
