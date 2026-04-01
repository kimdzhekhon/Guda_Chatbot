import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_markdown.dart';
import 'package:guda_chatbot/features/chat/domain/entities/message.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/message_actions.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

class MessageContent extends StatelessWidget {
  const MessageContent({
    super.key,
    required this.message,
    required this.isUser,
    required this.showActions,
    required this.shareKey,
  });

  final Message message;
  final bool isUser;
  final bool showActions;
  final GlobalKey shareKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isUser)
          Text(
            message.content,
            style: GudaTypography.body1(color: context.onUserBubbleColor),
          )
        else
          GudaMarkdown(
            data: message.content,
          ),
        if (!isUser && !message.isStreaming && showActions) ...[
          const SizedBox(height: GudaSpacing.sm),
          GudaMessageActions(
            message: message,
            shareKey: shareKey,
          ),
        ],
      ],
    );
  }
}
