import 'package:flutter/foundation.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/features/settings/data/datasources/notice_datasource.dart';
import 'package:guda_chatbot/features/settings/domain/entities/notice.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notice_viewmodel.g.dart';

/// 공지사항 상태 관리
@riverpod
class NoticeNotifier extends _$NoticeNotifier {
  late final NoticeDatasource _datasource;

  @override
  UiState<List<Notice>> build() {
    _datasource = NoticeDatasource();
    _fetchNotices();
    return const UiLoading();
  }

  Future<void> _fetchNotices() async {
    try {
      final notices = await _datasource.getNotices();
      state = UiSuccess(notices);
    } catch (e) {
      debugPrint('[NoticeViewModel] 공지사항 로드 실패: $e');
      state = UiError(e.toString());
    }
  }

  /// 새로고침
  Future<void> refresh() async {
    state = const UiLoading();
    await _fetchNotices();
  }
}
