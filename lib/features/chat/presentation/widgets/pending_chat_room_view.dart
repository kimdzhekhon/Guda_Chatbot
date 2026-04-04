import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/domain/entities/persona_type.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_usage_viewmodel.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_viewmodels.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/home_viewmodel.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/message_list.dart';
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
  final _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 첫 메시지 전송 시:
  /// 1. 현재 페르소나로 대화방 생성
  /// 2. HomeViewModel 상태를 실제 방 ID로 즉시 전환 (UI 교체 트리거)
  /// 3. ChatRoomViewModel이 이어받아 메시지를 전송
  Future<void> _handleFirstMessage(String text) async {
    if (_isSending) return;

    // 남은 대화 횟수 사전 체크 — 대화방 생성 전에 차단
    final usage = ref.read(chatUsageViewModelProvider);
    if (usage.remainingCount <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.noCreditMessage)),
        );
      }
      return;
    }

    if (mounted) setState(() => _isSending = true);

    try {
      // 1. 페르소나 조회
      final personaState = ref.read(personaProvider);
      final personaType = personaState.when(
        loading: () => PersonaType.basic,
        success: (p) => p,
        error: (error, stackTrace) => PersonaType.basic,
      );
      final personaId = personaType.name;

      // 2. 주역 괘 번호 캡처
      String finalContent = text;
      String? hexagramId;
      if (widget.topicCode == ClassicType.iching) {
        final hexagram = ref.read(homeViewModelProvider).selectedHexagram;
        if (hexagram != null) {
          hexagramId = hexagram.id.toString();
        }
      }

      // 3. 대화방 생성
      final title = text.length > 20 ? '${text.substring(0, 20)}…' : text;
      final createUseCase = ref.read(createConversationUseCaseProvider);
      final newConversation = await createUseCase(
        title: title,
        topicCode: widget.topicCode.name,
        personaId: personaId,
        hexagramId: hexagramId,
      );

      // 4. HomeViewModel에 방 ID 등록 → 즉시 PendingChatRoomView가 unmount되고
      //    ChatRoomView가 마운트됨. 이 시점 이후로 _isSending setState를 호출하면 안 됨.
      ref.read(homeViewModelProvider.notifier).setActiveChatRoomId(newConversation.id);

      // 6. ChatRoomViewModel을 통해 메시지 전송 (fire-and-forget)
      //    Pending 위젯은 이미 unmount 되었으므로 await하지 않음.
      ref
          .read(chatRoomViewModelProvider(newConversation.id).notifier)
          .sendMessage(
            content: finalContent,
            topicCode: widget.topicCode,
            hexagramId: hexagramId,
          );
    } catch (e) {
      // 에러 시 위젯이 아직 살아있는 경우에만 상태 복원
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('대화방 생성에 실패했습니다: $e')),
        );
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show input bar only if type is tripitaka (same logic as ChatRoomView for empty messages)
    final showInput = widget.topicCode == ClassicType.tripitaka;

    return Column(
      children: [
        Expanded(
          child: MessageList(
            messages: const [],
            type: widget.topicCode,
            scrollController: _scrollController,
            onSendMessage: _handleFirstMessage,
            activeChatRoomId: 'mock-new-pending',
          ),
        ),
        if (showInput)
          ChatInputBar(
            isLoading: _isSending,
            onSend: _handleFirstMessage,
            maxLength: widget.topicCode == ClassicType.iching ? 100 : 500,
          ),
      ],
    );
  }
}
