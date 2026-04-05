import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// Google Play 인앱 결제 데이터 소스
class IapDatasource {
  final InAppPurchase _iap = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final _purchaseController =
      StreamController<List<PurchaseDetails>>.broadcast();

  Stream<List<PurchaseDetails>> get purchaseStream =>
      _purchaseController.stream;

  /// 초기화 및 구매 스트림 리스닝 시작
  Future<bool> initialize() async {
    final available = await _iap.isAvailable();
    if (!available) return false;

    _subscription = _iap.purchaseStream.listen(
      (purchases) => _purchaseController.add(purchases),
      onError: (error) => _purchaseController.addError(error),
    );
    return true;
  }

  /// Google Play에서 상품 정보 조회
  Future<List<ProductDetails>> queryProducts(Set<String> productIds) async {
    final response = await _iap.queryProductDetails(productIds);
    if (response.error != null) {
      debugPrint('IAP 상품 조회 실패: ${response.error!.message}');
    }
    return response.productDetails;
  }

  /// 소모성 상품 구매 (충전)
  Future<bool> buyConsumable(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    return _iap.buyConsumable(purchaseParam: purchaseParam);
  }

  /// 비소모성 상품 구매 (구독)
  Future<bool> buyNonConsumable(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    return _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// 구매 완료 처리
  Future<void> completePurchase(PurchaseDetails purchase) async {
    if (purchase.pendingCompletePurchase) {
      await _iap.completePurchase(purchase);
    }
  }

  /// 리소스 해제
  void dispose() {
    _subscription?.cancel();
    _purchaseController.close();
  }
}
