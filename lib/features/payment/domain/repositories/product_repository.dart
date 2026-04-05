import 'package:guda_chatbot/features/payment/domain/entities/payment_plan.dart';
import 'package:guda_chatbot/features/payment/domain/entities/transaction_log.dart';

/// 결제 상품 리포지토리 인터페이스
abstract class ProductRepository {
  Future<List<PaymentPlan>> getPaymentPlans();
  Future<List<TransactionLog>> getTransactionLogs();
  Future<bool> purchasePlan(PaymentPlan plan);
}
