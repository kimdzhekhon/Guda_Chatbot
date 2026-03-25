import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_message_item.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_markdown.dart';
import 'package:guda_chatbot/features/chat/domain/entities/message.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/constants/app_assets.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/message_actions.dart';

class MessageBubble extends ConsumerWidget {
  MessageBubble({
    super.key,
    required this.message,
    required this.isDark,
    this.showActions = true,
  });

  final Message message;
  final bool isDark;
  final bool showActions;
  final GlobalKey _shareKey = GlobalKey();

  bool get isUser => message.role == MessageRole.user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUser) ...[
          Padding(
            padding: const EdgeInsets.only(top: GudaSpacing.sm, left: GudaSpacing.md),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: isDark ? GudaColors.surfaceDark : GudaColors.surfaceLight,
              child: Padding(
                padding: const EdgeInsets.all(GudaSpacing.xs),
                child: Image.asset(AppAssets.appLogoTransparent),
              ),
            ),
          ),
        ],
        Flexible(
          child: Column(
            crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              GudaMessageItem(
                isUser: isUser,
                isDark: isDark,
                isStreaming: message.isStreaming,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isUser)
                      Text(
                        message.content,
                        style: GudaTypography.body1(color: GudaColors.onUserBubble),
                      )
                    else
                      GudaMarkdown(
                        data: message.content,
                        isDark: isDark,
                      ),
                    if (!isUser && !message.isStreaming && showActions) ...[
                      const SizedBox(height: GudaSpacing.sm),
                      GudaMessageActions(
                        message: message,
                        isDark: isDark,
                        shareKey: _shareKey,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
