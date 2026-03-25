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
    required this.isDark,
    required this.type,
    required this.scrollController,
    required this.onSendMessage,
    required this.activeConversationId,
  });

  final List<Message> messages;
  final bool isDark;
  final ClassicType type;
  final ScrollController scrollController;
  final Function(String) onSendMessage;
  final String activeConversationId;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      if (type == ClassicType.tripitaka) {
        // 팔만대장경은 채팅 형식으로 시작
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(vertical: GudaSpacing.sm),
          children: [
            MessageBubble(
              message: Message(
                id: 'tripitaka-guidance',
                conversationId: activeConversationId,
                content: type.guidanceMessage,
                role: MessageRole.assistant,
                createdAt: DateTime.now(),
              ),
              isDark: isDark,
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
        duration: const Duration(milliseconds: 600),
        beginScale: 0.95,
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: GudaSpacing.sm),
      itemCount: messages.length,
      itemBuilder: (context, index) =>
          MessageBubble(message: messages[index], isDark: isDark),
    );
  }
}
