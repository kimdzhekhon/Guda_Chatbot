import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:guda_chatbot/features/chat/domain/entities/chat_usage.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_viewmodels.dart';

part 'chat_usage_viewmodel.g.dart';

/// 대화 사용량 관리 ViewModel (DB 연동)
@Riverpod(keepAlive: true)
class ChatUsageViewModel extends _$ChatUsageViewModel {
  @override
  ChatUsage build() {
    // 인증 상태 감시 — 로그인/로그아웃 또는 사용자 정보 변경 시 build가 재실행되어 데이터를 초기화하고 다시 로드합니다.
    final authState = ref.watch(authViewModelProvider);
    
    // 사용자가 로그인된 상태라면 데이터 로드 트리거
    if (authState is UiSuccess && authState.dataOrNull != null) {
      Future.microtask(() => loadUsage());
    }

    return const ChatUsage(
      remainingCount: 0,
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

  /// 외부에서 사용량 상태를 직접 갱신 (save_chat_message 결과 반영용)
  void updateUsage(ChatUsage usage) {
    state = usage;
  }
}
