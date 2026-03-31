// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productDataSource)
final productDataSourceProvider = ProductDataSourceProvider._();

final class ProductDataSourceProvider
    extends
        $FunctionalProvider<
          SupabaseProductDataSource,
          SupabaseProductDataSource,
          SupabaseProductDataSource
        >
    with $Provider<SupabaseProductDataSource> {
  ProductDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productDataSourceHash();

  @$internal
  @override
  $ProviderElement<SupabaseProductDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SupabaseProductDataSource create(Ref ref) {
    return productDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupabaseProductDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupabaseProductDataSource>(value),
    );
  }
}

String _$productDataSourceHash() => r'9f699a0bda46c0e936542c79f2f1c4c4ed40d9ae';

@ProviderFor(productRepository)
final productRepositoryProvider = ProductRepositoryProvider._();

final class ProductRepositoryProvider
    extends
        $FunctionalProvider<
          ProductRepository,
          ProductRepository,
          ProductRepository
        >
    with $Provider<ProductRepository> {
  ProductRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProductRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProductRepository create(Ref ref) {
    return productRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductRepository>(value),
    );
  }
}

String _$productRepositoryHash() => r'86e34057e303fb0208dcec15f8116d85b598fa26';

@ProviderFor(getPaymentPlansUseCase)
final getPaymentPlansUseCaseProvider = GetPaymentPlansUseCaseProvider._();

final class GetPaymentPlansUseCaseProvider
    extends
        $FunctionalProvider<
          GetPaymentPlansUseCase,
          GetPaymentPlansUseCase,
          GetPaymentPlansUseCase
        >
    with $Provider<GetPaymentPlansUseCase> {
  GetPaymentPlansUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getPaymentPlansUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getPaymentPlansUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetPaymentPlansUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetPaymentPlansUseCase create(Ref ref) {
    return getPaymentPlansUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetPaymentPlansUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetPaymentPlansUseCase>(value),
    );
  }
}

String _$getPaymentPlansUseCaseHash() =>
    r'850e4fe37e669446704e768945b16bd94e1d55cd';

@ProviderFor(PaymentViewModel)
final paymentViewModelProvider = PaymentViewModelProvider._();

final class PaymentViewModelProvider
    extends $AsyncNotifierProvider<PaymentViewModel, PaymentState> {
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
}

String _$paymentViewModelHash() => r'd6227c4f9484134a7ba34c18e34e3c1e26bc2bf3';

abstract class _$PaymentViewModel extends $AsyncNotifier<PaymentState> {
  FutureOr<PaymentState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PaymentState>, PaymentState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PaymentState>, PaymentState>,
              AsyncValue<PaymentState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
