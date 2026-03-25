// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'font_size_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// FontSizeViewModel — 전역 글씨 크기 상태 관리
/// 3단계 슬라이더 (0.85, 1.0, 1.15)를 지원합니다.

@ProviderFor(FontSizeViewModel)
final fontSizeViewModelProvider = FontSizeViewModelProvider._();

/// FontSizeViewModel — 전역 글씨 크기 상태 관리
/// 3단계 슬라이더 (0.85, 1.0, 1.15)를 지원합니다.
final class FontSizeViewModelProvider
    extends $AsyncNotifierProvider<FontSizeViewModel, double> {
  /// FontSizeViewModel — 전역 글씨 크기 상태 관리
  /// 3단계 슬라이더 (0.85, 1.0, 1.15)를 지원합니다.
  FontSizeViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fontSizeViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fontSizeViewModelHash();

  @$internal
  @override
  FontSizeViewModel create() => FontSizeViewModel();
}

String _$fontSizeViewModelHash() => r'4a6cf213ff2d6d8d73cf569fd0e5b2bec415970f';

/// FontSizeViewModel — 전역 글씨 크기 상태 관리
/// 3단계 슬라이더 (0.85, 1.0, 1.15)를 지원합니다.

abstract class _$FontSizeViewModel extends $AsyncNotifier<double> {
  FutureOr<double> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<double>, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<double>, double>,
              AsyncValue<double>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
