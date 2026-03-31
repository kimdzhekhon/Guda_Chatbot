import 'package:guda_chatbot/features/payment/domain/entities/payment_plan.dart';
import 'package:guda_chatbot/features/payment/domain/repositories/product_repository.dart';

/// 모든 결제 플랜을 가져오는 유즈케이스
class GetPaymentPlansUseCase {
  final ProductRepository _repository;

  GetPaymentPlansUseCase(this._repository);

  Future<List<PaymentPlan>> execute() async {
    return await _repository.getPaymentPlans();
  }
}
