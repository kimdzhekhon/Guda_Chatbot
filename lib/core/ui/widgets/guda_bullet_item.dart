import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// Guda 공통 불렛 아이템 위젯
class GudaBulletItem extends StatelessWidget {
  const GudaBulletItem({
    super.key,
    required this.content,
    required this.isDark,
    this.bulletColor,
  });

  final String content;
  final bool isDark;
  final Color? bulletColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: GudaSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: GudaTypography.body2Bold(
              color: bulletColor ?? GudaColors.primary,
            ),
          ),
          Expanded(
            child: Text(
              content,
              style: GudaTypography.body2(
                color: isDark
                    ? GudaColors.onSurfaceVariantDark
                    : GudaColors.onSurfaceVariantLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
