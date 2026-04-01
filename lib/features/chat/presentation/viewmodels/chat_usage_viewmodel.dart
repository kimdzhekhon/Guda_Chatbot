import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/chat_usage.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_viewmodels.dart';

part 'chat_usage_viewmodel.g.dart';

/// 대화 사용량 관리 ViewModel (DB 연동)
@Riverpod(keepAlive: true)
class ChatUsageViewModel extends _$ChatUsageViewModel {
  @override
  ChatUsage build() {
    // 초기값 (DB 로딩 전 표시용)
    Future.microtask(() => loadUsage());
    return const ChatUsage(
      usedCount: 0,
      totalLimit: 0,
      planName: '',
    );
  }

  /// DB에서 현재 사용량 로드
  Future<void> loadUsage() async {
    try {
      final repo = ref.read(chatRepositoryProvider);
      final usage = await repo.getChatUsage();
      if (!ref.mounted) return;
      state = usage;
    } catch (e) {
      debugPrint('[ChatUsage] 사용량 조회 실패: $e');
    }
  }

  /// 대화 크레딧 1회 차감 (DB 반영)
  /// 성공 시 true, 실패(잔여 횟수 없음 등) 시 false 반환
  Future<bool> useChatCredit() async {
    // 로컬 선차감 (낙관적 업데이트)
    final previous = state;
    if (state.remainingCount <= 0) return false;
    state = state.copyWith(usedCount: state.usedCount + 1);

    try {
      final repo = ref.read(chatRepositoryProvider);
      final usage = await repo.useChatCredit();
      if (!ref.mounted) return true;
      state = usage;
      return true;
    } catch (e) {
      debugPrint('[ChatUsage] 크레딧 차감 실패: $e');
      // 실패 시 롤백
      if (ref.mounted) state = previous;
      return false;
    }
  }
}
