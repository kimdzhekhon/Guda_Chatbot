import 'package:flutter/foundation.dart';
import 'package:guda_chatbot/features/payment/data/datasources/iap_datasource.dart';
import 'package:guda_chatbot/features/payment/data/datasources/supabase_product_datasource.dart';
import 'package:guda_chatbot/features/payment/domain/entities/payment_plan.dart';
import 'package:guda_chatbot/features/payment/domain/entities/transaction_log.dart';
import 'package:guda_chatbot/features/payment/domain/repositories/product_repository.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// 결제 상품 리포지토리 구현체
class ProductRepositoryImpl implements ProductRepository {
  final SupabaseProductDataSource _dataSource;
  final IapDatasource _iapDatasource;

  /// 조회된 Google Play 상품 정보 캐시
  final Map<String, ProductDetails> _productDetailsCache = {};

  ProductRepositoryImpl({
    required SupabaseProductDataSource dataSource,
    required IapDatasource iapDatasource,
  })  : _dataSource = dataSource,
        _iapDatasource = iapDatasource;

  @override
  Future<List<PaymentPlan>> getPaymentPlans() async {
    final dtos = await _dataSource.fetchProducts();
    final plans = dtos.map((dto) => dto.toEntity()).toList();

    // Google Play 상품 정보 미리 조회하여 캐시
    final googleIds = plans
        .where((p) => p.googleProductId != null)
        .map((p) => p.googleProductId!)
        .toSet();

    if (googleIds.isNotEmpty) {
      try {
        final details = await _iapDatasource.queryProducts(googleIds);
        for (final detail in details) {
          _productDetailsCache[detail.id] = detail;
        }
      } catch (e) {
        debugPrint('Google Play 상품 조회 실패: $e');
      }
    }

    return plans;
  }

  @override
  Future<List<TransactionLog>> getTransactionLogs() async {
    final dtos = await _dataSource.fetchTransactionLogs();
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<bool> purchasePlan(PaymentPlan plan) async {
    final googleId = plan.googleProductId;
    if (googleId == null) {
      throw Exception('Google Play 상품 ID가 없습니다.');
    }

    // 캐시에 없으면 다시 조회
    if (!_productDetailsCache.containsKey(googleId)) {
      final details = await _iapDatasource.queryProducts({googleId});
      if (details.isEmpty) {
        throw Exception('Google Play에서 상품을 찾을 수 없습니다: $googleId');
      }
      _productDetailsCache[googleId] = details.first;
    }

    final productDetails = _productDetailsCache[googleId]!;

    if (plan.type == PaymentType.subscription) {
      return _iapDatasource.buyNonConsumable(productDetails);
    } else {
      return _iapDatasource.buyConsumable(productDetails);
    }
  }
}
