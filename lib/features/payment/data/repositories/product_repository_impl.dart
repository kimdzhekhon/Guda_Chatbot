import 'package:guda_chatbot/features/payment/data/datasources/supabase_product_datasource.dart';
import 'package:guda_chatbot/features/payment/domain/entities/payment_plan.dart';
import 'package:guda_chatbot/features/payment/domain/repositories/product_repository.dart';

/// 결제 상품 리포지토리 구현체
class ProductRepositoryImpl implements ProductRepository {
  final SupabaseProductDataSource _dataSource;

  ProductRepositoryImpl({SupabaseProductDataSource? dataSource})
      : _dataSource = dataSource ?? SupabaseProductDataSource();

  @override
  Future<List<PaymentPlan>> getPaymentPlans() async {
    final dtos = await _dataSource.fetchProducts();
    // DTO를 엔티티로 변환
    return dtos.map((dto) => dto.toEntity()).toList();
  }
}
