import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:guda_chatbot/features/payment/data/datasources/iap_datasource.dart';
import 'package:guda_chatbot/features/payment/data/datasources/supabase_product_datasource.dart';
import 'package:guda_chatbot/features/payment/data/repositories/product_repository_impl.dart';
import 'package:guda_chatbot/features/payment/domain/entities/payment_plan.dart';
import 'package:guda_chatbot/features/payment/domain/repositories/product_repository.dart';
import 'package:guda_chatbot/features/payment/domain/usecases/get_payment_plans_usecase.dart';
import 'package:guda_chatbot/features/payment/domain/usecases/get_transaction_logs_usecase.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_viewmodels.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_viewmodel.g.dart';

/// 구매 결과 상태
enum PurchaseResultStatus { idle, pending, success, error, cancelled }

/// 결제 상태 클래스
class PaymentState {
  final List<PaymentPlan> subscriptionPlans;
  final List<PaymentPlan> chargePlans;
  final PaymentType selectedType;
  final PurchaseResultStatus purchaseStatus;
  final String? purchaseMessage;

  PaymentState({
    required this.subscriptionPlans,
    required this.chargePlans,
    this.selectedType = PaymentType.subscription,
    this.purchaseStatus = PurchaseResultStatus.idle,
    this.purchaseMessage,
  });

  List<PaymentPlan> get currentPlans =>
      selectedType == PaymentType.subscription ? subscriptionPlans : chargePlans;

  PaymentState copyWith({
    List<PaymentPlan>? subscriptionPlans,
    List<PaymentPlan>? chargePlans,
    PaymentType? selectedType,
    PurchaseResultStatus? purchaseStatus,
    String? purchaseMessage,
  }) {
    return PaymentState(
      subscriptionPlans: subscriptionPlans ?? this.subscriptionPlans,
      chargePlans: chargePlans ?? this.chargePlans,
      selectedType: selectedType ?? this.selectedType,
      purchaseStatus: purchaseStatus ?? this.purchaseStatus,
      purchaseMessage: purchaseMessage,
    );
  }
}

//--- 의존성 주입 레이어 ---

@riverpod
SupabaseProductDataSource productDataSource(Ref ref) {
  final rpc = ref.watch(rpcInvokerProvider);
  return SupabaseProductDataSource(rpcInvoker: rpc);
}

@Riverpod(keepAlive: true)
IapDatasource iapDatasource(Ref ref) {
  final datasource = IapDatasource();
  datasource.initialize();
  ref.onDispose(() => datasource.dispose());
  return datasource;
}

@riverpod
ProductRepository productRepository(Ref ref) {
  final dataSource = ref.watch(productDataSourceProvider);
  final iapDatasource = ref.watch(iapDatasourceProvider);
  return ProductRepositoryImpl(
    dataSource: dataSource,
    iapDatasource: iapDatasource,
  );
}

@riverpod
GetPaymentPlansUseCase getPaymentPlansUseCase(Ref ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetPaymentPlansUseCase(repository);
}

@riverpod
GetTransactionLogsUseCase getTransactionLogsUseCase(Ref ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetTransactionLogsUseCase(repository);
}

//--- ViewModel 레이어 ---

@riverpod
class PaymentViewModel extends _$PaymentViewModel {
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  @override
  Future<PaymentState> build() async {
    _listenToPurchases();
    ref.onDispose(() => _purchaseSubscription?.cancel());
    return _loadPlans();
  }

  /// IAP 구매 스트림 리스닝
  void _listenToPurchases() {
    final iap = ref.read(iapDatasourceProvider);
    _purchaseSubscription = iap.purchaseStream.listen((purchases) {
      for (final purchase in purchases) {
        _handlePurchase(purchase);
      }
    });
  }

  /// 구매 상태 처리
  Future<void> _handlePurchase(PurchaseDetails purchase) async {
    final iap = ref.read(iapDatasourceProvider);
    final currentState = state.value;

    switch (purchase.status) {
      case PurchaseStatus.purchased:
      case PurchaseStatus.restored:
        // TODO: 서버 영수증 검증 (Edge Function) 후 크레딧 충전
        debugPrint('구매 성공: ${purchase.productID}');
        await iap.completePurchase(purchase);
        if (currentState != null) {
          state = AsyncData(currentState.copyWith(
            purchaseStatus: PurchaseResultStatus.success,
            purchaseMessage: '구매가 완료되었습니다!',
          ));
        }
        break;
      case PurchaseStatus.error:
        debugPrint('구매 실패: ${purchase.error?.message}');
        if (currentState != null) {
          state = AsyncData(currentState.copyWith(
            purchaseStatus: PurchaseResultStatus.error,
            purchaseMessage: purchase.error?.message ?? '구매에 실패했습니다.',
          ));
        }
        break;
      case PurchaseStatus.canceled:
        debugPrint('구매 취소');
        if (currentState != null) {
          state = AsyncData(currentState.copyWith(
            purchaseStatus: PurchaseResultStatus.cancelled,
            purchaseMessage: null,
          ));
        }
        break;
      case PurchaseStatus.pending:
        debugPrint('구매 대기 중: ${purchase.productID}');
        if (currentState != null) {
          state = AsyncData(currentState.copyWith(
            purchaseStatus: PurchaseResultStatus.pending,
            purchaseMessage: '결제 처리 중입니다...',
          ));
        }
        break;
    }
  }

  Future<PaymentState> _loadPlans() async {
    final useCase = ref.read(getPaymentPlansUseCaseProvider);
    final allPlans = await useCase.execute();

    final subscriptionPlans = allPlans
        .where((p) => p.type == PaymentType.subscription)
        .toList();

    final chargePlans = allPlans
        .where((p) => p.type == PaymentType.charge && p.price > 0)
        .toList();

    return PaymentState(
      subscriptionPlans: subscriptionPlans,
      chargePlans: chargePlans,
    );
  }

  /// 탭 타입 변경
  Future<void> selectType(PaymentType type) async {
    final currentState = state.value;
    if (currentState != null) {
      state = AsyncData(currentState.copyWith(selectedType: type));
    }
  }

  /// 플랜 구매 시작
  Future<void> purchase(PaymentPlan plan) async {
    final currentState = state.value;
    if (currentState != null) {
      state = AsyncData(currentState.copyWith(
        purchaseStatus: PurchaseResultStatus.pending,
        purchaseMessage: '결제를 시작합니다...',
      ));
    }

    try {
      final repository = ref.read(productRepositoryProvider);
      await repository.purchasePlan(plan);
    } catch (e) {
      debugPrint('구매 시작 실패: $e');
      if (currentState != null) {
        state = AsyncData(currentState.copyWith(
          purchaseStatus: PurchaseResultStatus.error,
          purchaseMessage: '결제를 시작할 수 없습니다: $e',
        ));
      }
    }
  }

  /// 구매 상태 초기화
  void clearPurchaseStatus() {
    final currentState = state.value;
    if (currentState != null) {
      state = AsyncData(currentState.copyWith(
        purchaseStatus: PurchaseResultStatus.idle,
        purchaseMessage: null,
      ));
    }
  }

  /// 데이터 새로고침
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadPlans());
  }
}
