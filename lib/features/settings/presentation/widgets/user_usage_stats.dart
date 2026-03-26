import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_progress_bar.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

class UserUsageStats extends StatelessWidget {
  const UserUsageStats({
    super.key,
    required this.label,
    required this.progress,
    required this.remainingText,
  });

  final String label;
  final double progress;
  final String remainingText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GudaTypography.caption(
                color: context.onSurfaceVariantColor,
              ),
            ),
            Text(
              remainingText,
              style: GudaTypography.captionBold(
                color: context.onSurfaceVariantColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: GudaSpacing.xs),
        GudaProgressBar(value: progress),
      ],
    );
  }
}
