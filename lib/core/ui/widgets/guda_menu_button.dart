import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

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
    this.isLoading = false,
    this.height = 54,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final String? iconPath;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? (isDark ? Colors.black : Colors.white),
          foregroundColor: foregroundColor ?? (isDark ? Colors.white : GudaColors.onSurfaceLight),
          side: BorderSide(
            color: (isDark ? GudaColors.dividerDark : GudaColors.dividerLight)
                .withValues(alpha: 0.1),
          ),
          shape: RoundedRectangleBorder(borderRadius: GudaRadius.mdAll),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (iconPath != null)
                    Image.asset(iconPath!, width: 20, height: 20)
                  else if (icon != null)
                    Icon(icon, size: 20),
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
    );
  }
}
