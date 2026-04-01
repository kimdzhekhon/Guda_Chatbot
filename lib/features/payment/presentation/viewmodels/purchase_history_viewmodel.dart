import 'package:guda_chatbot/features/payment/domain/entities/transaction_log.dart';
import 'package:guda_chatbot/features/payment/presentation/viewmodels/payment_viewmodel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'purchase_history_viewmodel.g.dart';

@riverpod
class PurchaseHistoryViewModel extends _$PurchaseHistoryViewModel {
  @override
  Future<List<TransactionLog>> build() async {
    return _loadLogs();
  }

  Future<List<TransactionLog>> _loadLogs() async {
    final useCase = ref.read(getTransactionLogsUseCaseProvider);
    return await useCase.execute();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadLogs());
  }
}
