import 'package:guda_chatbot/features/payment/data/datasources/supabase_product_datasource.dart';
import 'package:guda_chatbot/features/payment/data/repositories/product_repository_impl.dart';
import 'package:guda_chatbot/features/payment/domain/entities/payment_plan.dart';
import 'package:guda_chatbot/features/payment/domain/entities/transaction_log.dart';
import 'package:guda_chatbot/features/payment/domain/repositories/product_repository.dart';
import 'package:guda_chatbot/features/payment/domain/usecases/get_payment_plans_usecase.dart';
import 'package:guda_chatbot/features/payment/domain/usecases/get_transaction_logs_usecase.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_viewmodels.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_viewmodel.g.dart';

/// 결제 상태 클래스
class PaymentState {
  final List<PaymentPlan> subscriptionPlans;
  final List<PaymentPlan> chargePlans;
  final PaymentType selectedType;

  PaymentState({
    required this.subscriptionPlans,
    required this.chargePlans,
    this.selectedType = PaymentType.subscription,
  });

  List<PaymentPlan> get currentPlans =>
      selectedType == PaymentType.subscription ? subscriptionPlans : chargePlans;

  PaymentState copyWith({
    List<PaymentPlan>? subscriptionPlans,
    List<PaymentPlan>? chargePlans,
    PaymentType? selectedType,
  }) {
    return PaymentState(
      subscriptionPlans: subscriptionPlans ?? this.subscriptionPlans,
      chargePlans: chargePlans ?? this.chargePlans,
      selectedType: selectedType ?? this.selectedType,
    );
  }
}

//--- 의존성 주입 레이어 ---

@riverpod
SupabaseProductDataSource productDataSource(Ref ref) {
  final rpc = ref.watch(rpcInvokerProvider);
  return SupabaseProductDataSource(rpcInvoker: rpc);
}

@riverpod
ProductRepository productRepository(Ref ref) {
  final dataSource = ref.watch(productDataSourceProvider);
  return ProductRepositoryImpl(dataSource: dataSource);
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
  @override
  Future<PaymentState> build() async {
    return _loadPlans();
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
    // state 자체가 AsyncValue이므로 state.value로 접근 (해당 버전에서는 valueOrNull 대신 value 사용)
    final currentState = state.value;
    if (currentState != null) {
      state = AsyncData(currentState.copyWith(selectedType: type));
    }
  }

  /// 데이터 새로고침
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadPlans());
  }
}
