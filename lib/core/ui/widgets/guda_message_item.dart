import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_animations.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_chat_bubble.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_streaming_dots.dart';

/// Guda 공통 메시지 아이템 — 목록 내 개별 메시지 레벨 레이아웃
class GudaMessageItem extends StatelessWidget {
  const GudaMessageItem({
    super.key,
    required this.child,
    required this.isUser,
    this.isStreaming = false,
  });

  final Widget child;
  final bool isUser;
  final bool isStreaming;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isUser ? GudaSpacing.xxxl : GudaSpacing.md,
        right: isUser ? GudaSpacing.md : GudaSpacing.xxxl,
        top: GudaSpacing.xs,
        bottom: GudaSpacing.xs,
      ),
      child: GudaChatBubble(
        isUser: isUser,
        child: isStreaming
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  child,
                  const SizedBox(height: GudaSpacing.xs),
                  const RepaintBoundary(child: GudaStreamingDots()),
                ],
              )
            : child,
      ),
    ).gudaFadeIn(
      duration: const Duration(milliseconds: 250),
    ).gudaSlideIn(
      begin: const Offset(0, 0.05),
    );
  }
}
