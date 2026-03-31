import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:guda_chatbot/features/payment/data/models/product_dto.dart';

/// Supabase 상품 데이터 소스
class SupabaseProductDataSource {
  final SupabaseClient _supabase;

  SupabaseProductDataSource({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// 모든 상품 목록 조회
  Future<List<ProductDto>> fetchProducts() async {
    final response = await _supabase.from('products').select();
    
    // Supabase v2 SDK에서는 .select() 결과가 List이므로 간소화
    return (response as List)
        .map((json) => ProductDto.fromJson(json))
        .toList();
  }
}
