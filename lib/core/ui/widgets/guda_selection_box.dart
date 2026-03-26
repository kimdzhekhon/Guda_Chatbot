import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

/// Guda 공통 선택 박스 위젯 (주역 궤 선택 등에서 사용)
class GudaSelectionBox extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const GudaSelectionBox({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return InkWell(
      onTap: onTap,
      borderRadius: GudaRadius.mdAll,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: GudaSpacing.lg),
        decoration: BoxDecoration(
          color: isDark
              ? GudaColors.surfaceVariantDark
              : GudaColors.surfaceVariantLight,
          borderRadius: GudaRadius.mdAll,
          border: Border.all(
            color: (isDark ? GudaColors.dividerDark : GudaColors.dividerLight)
                .withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: GudaColors.primary),
            const SizedBox(height: GudaSpacing.sm),
            Text(
              label,
              style: GudaTypography.button(
                color: isDark
                    ? GudaColors.onSurfaceDark
                    : GudaColors.onSurfaceLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
