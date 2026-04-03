import 'package:guda_chatbot/features/payment/data/models/product_dto.dart';
import 'package:guda_chatbot/features/payment/data/models/transaction_log_dto.dart';
import 'package:guda_chatbot/core/network/rpc_invoker.dart';

/// Supabase 상품 데이터 소스
class SupabaseProductDataSource {
  final RpcInvoker _rpcInvoker;

  SupabaseProductDataSource({
    required RpcInvoker rpcInvoker,
  })  : _rpcInvoker = rpcInvoker;

  /// 모든 상품 목록 조회 (RPC 전환으로 아키텍처 규칙 준수)
  Future<List<ProductDto>> fetchProducts() async {
    return _rpcInvoker.invokeList(
      functionName: 'get_products',
      fromJson: ProductDto.fromJson,
    );
  }

  /// 구매 내역 조회 (RPC 연동)
  Future<List<TransactionLogDto>> fetchTransactionLogs() async {
    // 서버 RPC가 auth.uid()를 사용하도록 개선됨에 따라 p_user_id 파라미터 제거
    return _rpcInvoker.invokeList(
      functionName: 'get_transaction_logs',
      fromJson: TransactionLogDto.fromJson,
    );
  }
}
