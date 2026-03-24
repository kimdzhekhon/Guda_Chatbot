import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_animations.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_chat_bubble.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_markdown.dart';
import 'package:guda_chatbot/features/chat/domain/entities/message.dart';

/// 채팅 메시지 버블 위젯
/// 사용자/AI 역할에 따라 좌우 정렬 및 색상이 자동으로 달라짐
class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message, required this.isDark});

  final Message message;
  final bool isDark;

  bool get isUser => message.role == MessageRole.user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isUser ? GudaSpacing.xxxl : GudaSpacing.md,
        right: isUser ? GudaSpacing.md : GudaSpacing.xxxl,
        top: GudaSpacing.xs,
        bottom: GudaSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          GudaChatBubble(
            isUser: isUser,
            isDark: isDark,
            child: isUser
                ? Text(
                    message.content,
                    style: GudaTypography.body1(color: GudaColors.onUserBubble),
                  )
                : GudaMarkdown(
                    data: message.content,
                    isDark: isDark,
                  ),
          ),
          if (message.isStreaming)
            const Padding(
              padding: EdgeInsets.only(top: GudaSpacing.xs),
              child: GudaStreamingDots(),
            ),
        ],
      ),
    ).gudaFadeIn(duration: const Duration(milliseconds: 250)).gudaSlideIn(begin: const Offset(0, 0.05));
  }
}
