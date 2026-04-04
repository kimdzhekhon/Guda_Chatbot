import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/constants/app_assets.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_menu_button.dart';

/// 소셜 로그인 프로바이더 종류
enum GudaSocialProvider { google, apple }

/// Guda 공통 소셜 로그인 버튼
/// Google, Apple 등 소셜 로그인 버튼의 일관된 규격(높이 54px, 둥근 모서리 등)을 제공합니다.
class GudaSocialButton extends StatelessWidget {
  const GudaSocialButton({
    super.key,
    required this.onPressed,
    required this.provider,
    this.isLoading = false,
    this.height = 54,
  });

  final VoidCallback? onPressed;
  final GudaSocialProvider provider;
  final bool isLoading;
  final double height;

  @override
  Widget build(BuildContext context) {
    final String label;
    final String iconPath;
    final Color backgroundColor;
    final Color foregroundColor;
    final Color? borderColor;

    switch (provider) {
      case GudaSocialProvider.google:
        label = AppStrings.continueWithGoogle;
        iconPath = AppAssets.googleIcon;
        backgroundColor = GudaColors.googleBackground;
        foregroundColor = GudaColors.google;
        borderColor = Colors.transparent;
        break;
      case GudaSocialProvider.apple:
        label = AppStrings.continueWithApple;
        iconPath = AppAssets.appleIcon;
        backgroundColor = GudaColors.apple;
        foregroundColor = GudaColors.onApple;
        borderColor = Colors.transparent;
        break;
    }

    return GudaMenuButton(
      onPressed: onPressed,
      label: label,
      iconPath: iconPath,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderColor: borderColor,
      iconSize: 28,
      isLoading: isLoading,
      height: height,
      isIconLeftAligned: true,
    );
  }
}
