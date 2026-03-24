import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
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
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          // AI 이름 제거됨 (사용자 요청)
          Container(
            decoration: BoxDecoration(
              color: _bubbleColor(isDark),
              borderRadius: isUser
                  ? GudaRadius.userBubble
                  : GudaRadius.assistantBubble,
              boxShadow: GudaShadows.bubble,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: GudaSpacing.md,
              vertical: GudaSpacing.md12,
            ),
            child: isUser
                ? Text(
                    message.content,
                    style: GudaTypography.body1(color: GudaColors.onUserBubble),
                  )
                : _buildAssistantContent(isDark),
          ),
          if (message.isStreaming)
            Padding(
              padding: const EdgeInsets.only(top: GudaSpacing.xs),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [_dot(0), _dot(1), _dot(2)],
              ),
            ),
        ],
      ),
    ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.05);
  }

  Widget _buildAssistantContent(bool isDark) {
    // AI 응답은 마크다운 렌더링
    return MarkdownBody(
      data: message.content.isEmpty ? '...' : message.content,
      styleSheet: MarkdownStyleSheet(
        p: GudaTypography.body1(
          color: isDark
              ? GudaColors.onAssistantBubbleDark
              : GudaColors.onAssistantBubbleLight,
        ),
        h2: GudaTypography.heading3(
          color: isDark
              ? GudaColors.onAssistantBubbleDark
              : GudaColors.onAssistantBubbleLight,
        ),
        code: GudaTypography.classicQuote(color: GudaColors.accent),
        horizontalRuleDecoration: BoxDecoration(
          border: Border.all(
            color: isDark ? GudaColors.dividerDark : GudaColors.dividerLight,
            width: 0.5,
          ),
        ),
      ),
    );
  }

  Color _bubbleColor(bool isDark) {
    if (isUser) {
      return isDark ? GudaColors.userBubbleDark : GudaColors.userBubbleLight;
    }
    return isDark
        ? GudaColors.assistantBubbleDark
        : GudaColors.assistantBubbleLight;
  }

  Widget _dot(int index) {
    return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: GudaColors.accent,
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .scaleXY(
          begin: 0.5,
          end: 1.0,
          delay: Duration(milliseconds: index * 150),
          duration: 400.ms,
          curve: Curves.easeInOut,
        )
        .then()
        .scaleXY(begin: 1.0, end: 0.5, duration: 400.ms);
  }
}
