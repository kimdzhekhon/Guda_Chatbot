import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_message_item.dart';
import 'package:guda_chatbot/features/chat/domain/entities/message.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:guda_chatbot/features/chat/presentation/widgets/message_avatar.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/message_content.dart';

class MessageBubble extends ConsumerWidget {
  MessageBubble({
    super.key,
    required this.message,
    this.showActions = true,
  });

  final Message message;
  final bool showActions;
  final GlobalKey _shareKey = GlobalKey();

  bool get isUser => message.role == MessageRole.user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUser) const MessageAvatar(),
        Flexible(
          child: Column(
            crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              GudaMessageItem(
                isUser: isUser,
                isStreaming: message.isStreaming,
                child: MessageContent(
                  message: message,
                  isUser: isUser,
                  showActions: showActions,
                  shareKey: _shareKey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
