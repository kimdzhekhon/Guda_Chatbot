import 'package:guda_chatbot/features/payment/domain/entities/transaction_log.dart';
import 'package:guda_chatbot/features/payment/domain/repositories/product_repository.dart';

/// 구매 내역을 가져오는 유즈케이스
class GetTransactionLogsUseCase {
  final ProductRepository _repository;

  GetTransactionLogsUseCase(this._repository);

  Future<List<TransactionLog>> execute() async {
    return await _repository.getTransactionLogs();
  }
}
