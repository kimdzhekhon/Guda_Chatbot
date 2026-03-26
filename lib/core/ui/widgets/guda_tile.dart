import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

/// Guda 공통 리스트 타일 위젯
/// 디자인 시스템에 따른 타이포그래피와 일관된 패딩, 아이콘 스타일을 제공합니다.
class GudaTile extends StatelessWidget {
  const GudaTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.leading,
    this.trailing,
    this.onTap,
    this.isSelected = false,
    this.color,
    this.iconColor,
    this.padding,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isSelected;
  final Color? color;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final colorScheme = Theme.of(context).colorScheme;

    // 기본 색상 설정
    final effectiveTextColor = isSelected
        ? colorScheme.primary
        : (color ?? (isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight));
    
    final effectiveIconColor = iconColor ?? effectiveTextColor;

    return InkWell(
      onTap: onTap,
      borderRadius: GudaRadius.smAll,
      child: Padding(
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: GudaSpacing.md,
              vertical: GudaSpacing.md,
            ),
        child: Row(
          children: [
            // ── Leading 영역 ──────────────────────
            if (leading != null) ...[
              leading!,
              const SizedBox(width: GudaSpacing.md),
            ] else if (icon != null) ...[
              Icon(
                icon,
                size: 24,
                color: effectiveIconColor,
              ),
              const SizedBox(width: GudaSpacing.md),
            ],

            // ── Title / Subtitle 영역 ─────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: isSelected
                        ? GudaTypography.body1Bold(color: effectiveTextColor)
                        : GudaTypography.body1(color: effectiveTextColor),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: GudaTypography.caption(
                        color: isDark
                            ? GudaColors.onSurfaceVariantDark
                            : GudaColors.onSurfaceVariantLight,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ── Trailing 영역 ─────────────────────
            if (trailing != null) ...[
              const SizedBox(width: GudaSpacing.sm),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
