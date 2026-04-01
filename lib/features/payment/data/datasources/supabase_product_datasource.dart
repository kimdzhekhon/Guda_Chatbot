import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:guda_chatbot/features/payment/data/models/product_dto.dart';
import 'package:guda_chatbot/features/payment/data/models/transaction_log_dto.dart';
import 'package:guda_chatbot/core/network/rpc_invoker.dart';

/// Supabase 상품 데이터 소스
class SupabaseProductDataSource {
  final SupabaseClient _supabase;
  final RpcInvoker _rpcInvoker;

  SupabaseProductDataSource({
    SupabaseClient? supabase,
    required RpcInvoker rpcInvoker,
  })  : _supabase = supabase ?? Supabase.instance.client,
        _rpcInvoker = rpcInvoker;

  /// 모든 상품 목록 조회
  Future<List<ProductDto>> fetchProducts() async {
    final response = await _supabase.from('products').select();
    
    // Supabase v2 SDK에서는 .select() 결과가 List이므로 간소화
    return (response as List)
        .map((json) => ProductDto.fromJson(json))
        .toList();
  }

  /// 구매 내역 조회 (RPC 연동)
  Future<List<TransactionLogDto>> fetchTransactionLogs() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    return _rpcInvoker.invokeList(
      functionName: 'get_transaction_logs',
      params: {'p_user_id': userId},
      fromJson: TransactionLogDto.fromJson,
    );
  }
}
