// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Auth 관련 Provider 의존성

@ProviderFor(supabaseAuthDataSource)
final supabaseAuthDataSourceProvider = SupabaseAuthDataSourceProvider._();

/// Auth 관련 Provider 의존성

final class SupabaseAuthDataSourceProvider
    extends
        $FunctionalProvider<
          SupabaseAuthDataSource,
          SupabaseAuthDataSource,
          SupabaseAuthDataSource
        >
    with $Provider<SupabaseAuthDataSource> {
  /// Auth 관련 Provider 의존성
  SupabaseAuthDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supabaseAuthDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supabaseAuthDataSourceHash();

  @$internal
  @override
  $ProviderElement<SupabaseAuthDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SupabaseAuthDataSource create(Ref ref) {
    return supabaseAuthDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupabaseAuthDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupabaseAuthDataSource>(value),
    );
  }
}

String _$supabaseAuthDataSourceHash() =>
    r'239b4abf6baf262f3584a6907a423ace5e711ef7';

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends
        $FunctionalProvider<
          AuthRepositoryImpl,
          AuthRepositoryImpl,
          AuthRepositoryImpl
        >
    with $Provider<AuthRepositoryImpl> {
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepositoryImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthRepositoryImpl create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepositoryImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepositoryImpl>(value),
    );
  }
}

String _$authRepositoryHash() => r'519da6b15afb088cfb679a4ff821d9dd0247b7ce';

@ProviderFor(signInWithGoogleUseCase)
final signInWithGoogleUseCaseProvider = SignInWithGoogleUseCaseProvider._();

final class SignInWithGoogleUseCaseProvider
    extends
        $FunctionalProvider<
          SignInWithGoogleUseCase,
          SignInWithGoogleUseCase,
          SignInWithGoogleUseCase
        >
    with $Provider<SignInWithGoogleUseCase> {
  SignInWithGoogleUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInWithGoogleUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInWithGoogleUseCaseHash();

  @$internal
  @override
  $ProviderElement<SignInWithGoogleUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SignInWithGoogleUseCase create(Ref ref) {
    return signInWithGoogleUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignInWithGoogleUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignInWithGoogleUseCase>(value),
    );
  }
}

String _$signInWithGoogleUseCaseHash() =>
    r'e677af0f5be96979b5ffb65257967d4357e7eb4d';

@ProviderFor(signOutUseCase)
final signOutUseCaseProvider = SignOutUseCaseProvider._();

final class SignOutUseCaseProvider
    extends $FunctionalProvider<SignOutUseCase, SignOutUseCase, SignOutUseCase>
    with $Provider<SignOutUseCase> {
  SignOutUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signOutUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signOutUseCaseHash();

  @$internal
  @override
  $ProviderElement<SignOutUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SignOutUseCase create(Ref ref) {
    return signOutUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignOutUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignOutUseCase>(value),
    );
  }
}

String _$signOutUseCaseHash() => r'43b88dc732fc2ec257d73871891f04dcae657f24';

@ProviderFor(getCurrentUserUseCase)
final getCurrentUserUseCaseProvider = GetCurrentUserUseCaseProvider._();

final class GetCurrentUserUseCaseProvider
    extends
        $FunctionalProvider<
          GetCurrentUserUseCase,
          GetCurrentUserUseCase,
          GetCurrentUserUseCase
        >
    with $Provider<GetCurrentUserUseCase> {
  GetCurrentUserUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCurrentUserUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCurrentUserUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetCurrentUserUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetCurrentUserUseCase create(Ref ref) {
    return getCurrentUserUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCurrentUserUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetCurrentUserUseCase>(value),
    );
  }
}

String _$getCurrentUserUseCaseHash() =>
    r'4c558036519273e5a4eae954197dcf61cff31679';

/// Auth ViewModel — Google 로그인/로그아웃 및 인증 상태 관리

@ProviderFor(AuthViewModel)
final authViewModelProvider = AuthViewModelProvider._();

/// Auth ViewModel — Google 로그인/로그아웃 및 인증 상태 관리
final class AuthViewModelProvider
    extends $NotifierProvider<AuthViewModel, UiState<GudaUser?>> {
  /// Auth ViewModel — Google 로그인/로그아웃 및 인증 상태 관리
  AuthViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authViewModelHash();

  @$internal
  @override
  AuthViewModel create() => AuthViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UiState<GudaUser?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UiState<GudaUser?>>(value),
    );
  }
}

String _$authViewModelHash() => r'6a13c0905d791f034a1422ec9315870897095fc3';

/// Auth ViewModel — Google 로그인/로그아웃 및 인증 상태 관리

abstract class _$AuthViewModel extends $Notifier<UiState<GudaUser?>> {
  UiState<GudaUser?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<UiState<GudaUser?>, UiState<GudaUser?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UiState<GudaUser?>, UiState<GudaUser?>>,
              UiState<GudaUser?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
