import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/domain/entities/persona_type.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_viewmodels.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_usage_viewmodel.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/home_viewmodel.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:guda_chatbot/features/settings/presentation/viewmodels/persona_viewmodel.dart';

/// Pending 상태의 새 대화 뷰
/// DB에 방이 아직 생성되지 않았으며, 사용자의 첫 메시지를 기다립니다.
/// 첫 메시지 전송 시 대화방을 생성하고 즉시 메시지를 전송합니다.
class PendingChatRoomView extends ConsumerStatefulWidget {
  const PendingChatRoomView({
    super.key,
    required this.topicCode,
  });

  final ClassicType topicCode;

  @override
  ConsumerState<PendingChatRoomView> createState() => _PendingChatRoomViewState();
}

class _PendingChatRoomViewState extends ConsumerState<PendingChatRoomView> {
  bool _isSending = false;

  /// 첫 메시지 전송 시:
  /// 1. 현재 페르소나로 대화방 생성
  /// 2. 생성된 방 ID로 메시지 전송 시작
  /// 3. HomeViewModel 상태를 실제 방 ID로 업데이트
  Future<void> _handleFirstMessage(String text) async {
    if (_isSending) return;
    setState(() => _isSending = true);

    try {
      // 1. 현재 페르소나 조회
      final personaState = ref.read(personaProvider);
      final personaType = personaState.when(
        loading: () => PersonaType.basic,
        success: (p) => p,
        error: (_, __) => PersonaType.basic,
      );
      final personaId = personaType.name;

      // 2. 대화방 생성 (첫 메시지 내용을 제목으로 사용)
      final title = text.length > 20 ? '${text.substring(0, 20)}…' : text;
      final createUseCase = ref.read(createConversationUseCaseProvider);
      final newConversation = await createUseCase(
        title: title,
        topicCode: widget.topicCode.name,
        personaId: personaId,
      );

      // 3. HomeViewModel에 방 ID 등록 (Pending → Active 전환 및 목록 갱신)
      ref.read(homeViewModelProvider.notifier).setActiveChatRoomId(newConversation.id);

      // 4. 사용량 증가
      ref.read(chatUsageViewModelProvider.notifier).incrementUsedCount();

      // 5. ChatRoomViewModel을 통해 메시지 전송
      await ref
          .read(chatRoomViewModelProvider(newConversation.id).notifier)
          .sendMessage(
            content: text,
            topicCode: widget.topicCode,
          );
    } catch (e) {
      // 에러 시 Pending 상태 유지, 사용자에게 알림
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('대화방 생성에 실패했습니다: $e')),
        );
      }
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 메시지 목록 영역 (아직 비어 있음 → 빈 공간)
        const Expanded(child: SizedBox.shrink()),
        // 입력창
        ChatInputBar(
          isLoading: _isSending,
          onSend: _handleFirstMessage,
        ),
      ],
    );
  }
}
