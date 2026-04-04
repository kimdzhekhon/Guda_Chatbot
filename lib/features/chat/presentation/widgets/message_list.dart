import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/domain/entities/message.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/initial_question_card.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/message_bubble.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_animations.dart';

class MessageList extends StatelessWidget {
  const MessageList({
    super.key,
    required this.messages,
    required this.type,
    required this.scrollController,
    required this.onSendMessage,
    required this.activeChatRoomId,
  });

  final List<Message> messages;
  final ClassicType type;
  final ScrollController scrollController;
  final Function(String) onSendMessage;
  final String activeChatRoomId;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      if (type == ClassicType.tripitaka) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(vertical: GudaSpacing.sm),
          children: [
            _StaticGuidanceBubble(
              content: type.guidanceMessage,
              chatRoomId: activeChatRoomId,
            ),
          ],
        );
      }

      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.lg),
          child: InitialQuestionCard(
            type: type,
            onSkip: () => onSendMessage(''),
            onStart: onSendMessage,
          ),
        ),
      ).gudaFadeScaleIn(
        duration: GudaDuration.slower,
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: GudaSpacing.sm),
      itemCount: messages.length,
      // Riverpod이 상태 관리하므로 자동 keepAlive 불필요 → 메모리 절약
      addAutomaticKeepAlives: false,
      itemBuilder: (context, index) => MessageBubble(
            key: ValueKey(messages[index].id),
            message: messages[index],
          ),
    );
  }
}

class _StaticGuidanceBubble extends StatelessWidget {
  const _StaticGuidanceBubble({
    required this.content,
    required this.chatRoomId,
  });

  final String content;
  final String chatRoomId;

  @override
  Widget build(BuildContext context) {
    return MessageBubble(
      message: Message(
        id: 0,
        chatRoomId: chatRoomId,
        content: content,
        senderRole: MessageRole.assistant,
        createdAt: DateTime(2024), // Use static date to avoid rebuild comparisons
        isSystem: true,
      ),
      showActions: false,
    );
  }
}
