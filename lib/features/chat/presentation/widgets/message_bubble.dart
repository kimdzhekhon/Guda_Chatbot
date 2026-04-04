import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_message_item.dart';
import 'package:guda_chatbot/features/chat/domain/entities/message.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:guda_chatbot/features/chat/presentation/widgets/message_avatar.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/message_content.dart';

class MessageBubble extends ConsumerStatefulWidget {
  const MessageBubble({
    super.key,
    required this.message,
    this.showActions = true,
  });

  final Message message;
  final bool showActions;

  @override
  ConsumerState<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends ConsumerState<MessageBubble> {
  // GlobalKey를 State에서 한 번만 생성 (기존: 매 build마다 새 GlobalKey 생성)
  final GlobalKey _shareKey = GlobalKey();

  bool get isUser => widget.message.senderRole == MessageRole.user;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) const MessageAvatar(),
          Flexible(
            child: GudaMessageItem(
              isUser: isUser,
              isStreaming: widget.message.isStreaming,
              child: MessageContent(
                message: widget.message,
                isUser: isUser,
                showActions: widget.showActions,
                shareKey: _shareKey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
