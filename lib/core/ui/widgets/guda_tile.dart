import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// Guda 공통 리스트 타일 위젯
/// 디자인 시스템에 따른 타이포그래피와 일관된 패딩, 아이콘 스타일을 제공합니다.
class GudaTile extends StatelessWidget {
  const GudaTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.selected = false,
    this.color,
    this.selectedTileColor,
    this.contentPadding,
  });

  final String title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;
  final Color? color;
  final Color? selectedTileColor;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      onTap: onTap,
      selected: selected,
      selectedTileColor: selectedTileColor ??
          (isDark ? GudaColors.primary : GudaColors.surfaceVariantLight)
              .withValues(alpha: 0.1),
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(
            horizontal: GudaSpacing.md,
            vertical: GudaSpacing.xs,
          ),
      leading: leading,
      title: Text(
        title,
        style: selected
            ? GudaTypography.body1Bold(
                color: color ??
                    (isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight),
              )
            : GudaTypography.body1(
                color: color ??
                    (isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight),
              ),
      ),
      subtitle: subtitle,
      trailing: trailing,
    );
  }
}
