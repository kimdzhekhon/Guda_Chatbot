// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_usage_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 대화 사용량 관리 ViewModel (DB 연동)

@ProviderFor(ChatUsageViewModel)
final chatUsageViewModelProvider = ChatUsageViewModelProvider._();

/// 대화 사용량 관리 ViewModel (DB 연동)
final class ChatUsageViewModelProvider
    extends $NotifierProvider<ChatUsageViewModel, ChatUsage> {
  /// 대화 사용량 관리 ViewModel (DB 연동)
  ChatUsageViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatUsageViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatUsageViewModelHash();

  @$internal
  @override
  ChatUsageViewModel create() => ChatUsageViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatUsage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatUsage>(value),
    );
  }
}

String _$chatUsageViewModelHash() =>
    r'4783abd4340dd66bb3254ef386c253d87316ecf9';

/// 대화 사용량 관리 ViewModel (DB 연동)

abstract class _$ChatUsageViewModel extends $Notifier<ChatUsage> {
  ChatUsage build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ChatUsage, ChatUsage>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatUsage, ChatUsage>,
              ChatUsage,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
