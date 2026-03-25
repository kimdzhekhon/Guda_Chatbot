// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PaymentViewModel)
final paymentViewModelProvider = PaymentViewModelProvider._();

final class PaymentViewModelProvider
    extends $NotifierProvider<PaymentViewModel, PaymentState> {
  PaymentViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentViewModelHash();

  @$internal
  @override
  PaymentViewModel create() => PaymentViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaymentState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaymentState>(value),
    );
  }
}

String _$paymentViewModelHash() => r'20d9cca82df025ee1fdfa932e2ab474fa2962ad1';

abstract class _$PaymentViewModel extends $Notifier<PaymentState> {
  PaymentState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PaymentState, PaymentState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PaymentState, PaymentState>,
              PaymentState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
