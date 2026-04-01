import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/network/share_service.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_button.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';
import 'package:guda_chatbot/features/chat/domain/entities/message.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/result_card.dart';

class SharePreviewDialog extends StatelessWidget {
  const SharePreviewDialog({
    super.key,
    required this.message,
    required this.shareKey,
  });

  final Message message;
  final GlobalKey shareKey;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: GudaSpacing.lg,
        vertical: GudaSpacing.xxl,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RepaintBoundary(
              key: shareKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: GudaSpacing.md,
                  vertical: GudaSpacing.sm,
                ),
                child: ResultCard(
                  title: AppStrings.aiAdviceTitle,
                  content: message.content,
                ),
              ),
            ),
            const SizedBox(height: GudaSpacing.md),
            GudaButton.filled(
              onPressed: () {
                ShareService.shareWidgetAsImage(
                  boundaryKey: shareKey,
                  fileName: 'guda_result_${message.id}',
                  text: AppStrings.aiAdviceMsg,
                );
                Navigator.pop(context);
              },
              icon: Icons.share,
              label: AppStrings.shareAsImage,
              backgroundColor: context.colorScheme.primary,
              foregroundColor: context.colorScheme.onPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
