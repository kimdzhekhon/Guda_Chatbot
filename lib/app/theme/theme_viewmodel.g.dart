// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ThemeViewModel — 앱 테마 모드 관리 (System, Light, Dark)

@ProviderFor(ThemeViewModel)
final themeViewModelProvider = ThemeViewModelProvider._();

/// ThemeViewModel — 앱 테마 모드 관리 (System, Light, Dark)
final class ThemeViewModelProvider
    extends $AsyncNotifierProvider<ThemeViewModel, ThemeMode> {
  /// ThemeViewModel — 앱 테마 모드 관리 (System, Light, Dark)
  ThemeViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeViewModelHash();

  @$internal
  @override
  ThemeViewModel create() => ThemeViewModel();
}

String _$themeViewModelHash() => r'896b03d9fce0736c85b7a8e59c5bc2f585365343';

/// ThemeViewModel — 앱 테마 모드 관리 (System, Light, Dark)

abstract class _$ThemeViewModel extends $AsyncNotifier<ThemeMode> {
  FutureOr<ThemeMode> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ThemeMode>, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ThemeMode>, ThemeMode>,
              AsyncValue<ThemeMode>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
