import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// Guda 공통 소셜 로그인 버튼
/// Google, Apple 등 소셜 로그인 버튼의 일관된 규격(높이 54px, 둥근 모서리 등)을 제공합니다.
class GudaSocialButton extends StatelessWidget {
  const GudaSocialButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.iconPath,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final String label;
  final String iconPath;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 54,
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
                  Image.asset(iconPath, width: 20, height: 20),
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
