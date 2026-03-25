import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/chat_usage.dart';

part 'chat_usage_viewmodel.g.dart';

/// 대화 사용량 관리 ViewModel
@riverpod
class ChatUsageViewModel extends _$ChatUsageViewModel {
  @override
  ChatUsage build() {
    // 초기값: 총 20회 중 0회 사용
    return const ChatUsage(
      usedCount: 0,
      totalLimit: 20,
    );
  }

  /// 대화 횟수 1회 증가
  void incrementUsedCount() {
    if (state.usedCount < state.totalLimit) {
      state = state.copyWith(usedCount: state.usedCount + 1);
    }
  }

  /// 사용량 초기화 (필요 시)
  void resetUsage() {
    state = state.copyWith(usedCount: 0);
  }
}
