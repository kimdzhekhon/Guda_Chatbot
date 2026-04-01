import 'dart:developer';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/features/auth/data/datasources/supabase_auth_datasource.dart';
import 'package:guda_chatbot/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:guda_chatbot/features/auth/domain/entities/guda_user.dart';
import 'package:guda_chatbot/features/auth/domain/usecases/auth_usecases.dart';
import 'package:guda_chatbot/features/chat/domain/entities/persona_type.dart';

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
  Future<void> checkSession() async {
    try {
      final user = await ref.read(getCurrentUserUseCaseProvider).call();
      state = UiSuccess(user);
    } catch (e) {
      state = const UiSuccess(null);
    }
  }

  /// Google 로그인/회원가입
  Future<void> signInWithGoogle({
    bool isSignUp = false,
    String? nickname,
    DateTime? birthDate,
    PersonaType? persona,
  }) async {
    state = const UiLoading();
    try {
      final user = await ref.read(signInWithGoogleUseCaseProvider).call();
      
      // 회원가입 전용 정보가 있는 경우 프로필 업데이트 수행
      if (isSignUp && nickname != null && birthDate != null && persona != null) {
        await ref.read(updateProfileUseCaseProvider).call(
          nickname: nickname,
          birthDate: birthDate,
          persona: persona,
          termsAgreed: true, // 소셜 로그인 페이지에서 가입 시 이미 동의한 것으로 간주
        );
        // 업데이트된 정보로 다시 조회 (캐시 갱신 효과)
        final updatedUser = await ref.read(getCurrentUserUseCaseProvider).call();
        state = UiSuccess(updatedUser);
      } else {
        state = UiSuccess(user);
      }
    } catch (e) {
      state = UiError('Google 로그인에 실패했습니다: ${e.toString()}');
    }
  }

  /// Apple 로그인/회원가입
  Future<void> signInWithApple({
    bool isSignUp = false,
    String? nickname,
    DateTime? birthDate,
    PersonaType? persona,
  }) async {
    state = const UiLoading();
    try {
      final user = await ref.read(signInWithAppleUseCaseProvider).call();
      
      if (isSignUp && nickname != null && birthDate != null && persona != null) {
        await ref.read(updateProfileUseCaseProvider).call(
          nickname: nickname,
          birthDate: birthDate,
          persona: persona,
          termsAgreed: true,
        );
        final updatedUser = await ref.read(getCurrentUserUseCaseProvider).call();
        state = UiSuccess(updatedUser);
      } else {
        state = UiSuccess(user);
      }
    } catch (e) {
      state = UiError('Apple 로그인에 실패했습니다: ${e.toString()}');
    }
  }

  /// 프로필 정보 업데이트 (온보딩 최종 단계)
  Future<void> updateProfile({
    required String nickname,
    required DateTime birthDate,
    required PersonaType persona,
    required bool termsAgreed,
  }) async {
    state = const UiLoading();
    try {
      await ref.read(updateProfileUseCaseProvider).call(
        nickname: nickname,
        birthDate: birthDate,
        persona: persona,
        termsAgreed: termsAgreed,
      );
      
      // 업데이트된 정보를 반영하기 위해 유저 정보 재조회
      final updatedUser = await ref.read(getCurrentUserUseCaseProvider).call();
      state = UiSuccess(updatedUser);
    } catch (e) {
      state = UiError('프로필 업데이트에 실패했습니다: ${e.toString()}');
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
