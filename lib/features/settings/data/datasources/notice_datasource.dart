import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:guda_chatbot/features/settings/domain/entities/notice.dart';

/// 공지사항 데이터소스 — system_config 테이블에서 공지 조회
class NoticeDatasource {
  NoticeDatasource() : _supabase = Supabase.instance.client;

  final SupabaseClient _supabase;

  /// 활성 공지사항 목록 조회
  Future<List<Notice>> getNotices() async {
    final response = await _supabase
        .from('system_config')
        .select()
        .not('notice_title', 'is', null) // 제목이 있는 경우만 공지로 간주
        .order('updated_at', ascending: false);

    return (response as List)
        .map((row) => Notice.fromSystemConfig(row as Map<String, dynamic>))
        .toList();
  }
}
