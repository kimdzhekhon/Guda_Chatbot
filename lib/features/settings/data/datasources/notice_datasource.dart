import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:guda_chatbot/features/settings/domain/entities/notice.dart';

/// 공지사항 데이터소스 — RPC를 통해 공지 조회 (아키텍처 규칙 준수)
class NoticeDatasource {
  NoticeDatasource() : _supabase = Supabase.instance.client;

  final SupabaseClient _supabase;

  /// 활성 공지사항 목록 조회
  Future<List<Notice>> getNotices() async {
    final List<dynamic> response = await _supabase.rpc('get_notices');

    return response
        .map((row) => Notice.fromSystemConfig(row as Map<String, dynamic>))
        .toList();
  }
}
