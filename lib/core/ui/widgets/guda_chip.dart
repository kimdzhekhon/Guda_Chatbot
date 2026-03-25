import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// Guda 공통 칩 위젯
/// 제안된 질문, 태그 등에 사용됩니다.
class GudaChip extends StatelessWidget {
  const GudaChip({
    super.key,
    required this.label,
    required this.onTap,
    this.isSelected = false,
    this.padding = const EdgeInsets.symmetric(
      horizontal: GudaSpacing.md,
      vertical: GudaSpacing.xs,
    ),
  });

  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: (isSelected
                  ? GudaColors.primary
                  : (isDark
                      ? GudaColors.surfaceVariantDark
                      : GudaColors.surfaceVariantLight))
              .withValues(alpha: isSelected ? 1.0 : 0.7),
          borderRadius: GudaRadius.fullAll,
          border: Border.all(
            color: (isDark ? GudaColors.dividerDark : GudaColors.dividerLight)
                .withValues(alpha: 0.5),
            width: isSelected ? 0 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GudaTypography.caption(
              color: isSelected
                  ? Colors.white
                  : (isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight),
            ).copyWith(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
