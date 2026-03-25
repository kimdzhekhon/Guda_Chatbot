import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// Guda 채팅 버블 베이스 위젯
/// 메시지 역할에 따른 배경색, 곡률, 패딩 디자인을 공통화합니다.
class GudaChatBubble extends StatelessWidget {
  const GudaChatBubble({
    super.key,
    required this.child,
    required this.isUser,
    required this.isDark,
    this.padding,
  });

  final Widget child;
  final bool isUser;
  final bool isDark;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _bubbleColor(),
        borderRadius: isUser ? GudaRadius.userBubble : GudaRadius.assistantBubble,
        boxShadow: GudaShadows.bubble,
      ),
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: GudaSpacing.md,
            vertical: GudaSpacing.md12,
          ),
      child: child,
    );
  }

  Color _bubbleColor() {
    if (isUser) {
      return isDark ? GudaColors.userBubbleDark : GudaColors.userBubbleLight;
    }
    return isDark
        ? GudaColors.assistantBubbleDark
        : GudaColors.assistantBubbleLight;
  }
}
