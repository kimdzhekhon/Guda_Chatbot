import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

/// Guda 공통 메뉴 버튼 위젯
/// 아이콘과 텍스트가 포함된 전폭(Full-width) 버튼입니다.
class GudaMenuButton extends StatelessWidget {
  const GudaMenuButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.iconPath,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.iconSize = GudaSpacing.md20,
    this.isLoading = false,
    this.height = 54,
    this.isIconLeftAligned = false,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final String? iconPath;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double iconSize;
  final bool isLoading;
  final double height;
  final bool isIconLeftAligned;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? (isDark ? GudaColors.surfaceDark : GudaColors.surfaceLight),
          foregroundColor: foregroundColor ?? (isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight),
          side: BorderSide(
            color: borderColor ?? (isDark ? GudaColors.dividerDark : GudaColors.dividerLight)
                .withValues(alpha: isDark ? 0.2 : 0.5),
          ),
          shape: const RoundedRectangleBorder(borderRadius: GudaRadius.mdAll),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: GudaSpacing.md20,
                height: GudaSpacing.md20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : isIconLeftAligned
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      // 아이콘: 왼쪽 고정
                      Positioned(
                        left: GudaSpacing.md,
                        child: iconPath != null
                            ? Image.asset(iconPath!, width: iconSize, height: iconSize)
                            : Icon(icon, size: iconSize),
                      ),
                      // 텍스트: 중앙 정렬
                      Text(
                        label,
                        style: GudaTypography.button(
                          color: foregroundColor,
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: GudaSpacing.md,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (iconPath != null)
                          Image.asset(iconPath!, width: iconSize, height: iconSize)
                        else if (icon != null)
                          Icon(icon, size: iconSize),
                        const SizedBox(width: GudaSpacing.md),
                        Text(
                          label,
                          style: GudaTypography.button(
                            color: foregroundColor,
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
