import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_menu_button.dart';

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

    return GudaMenuButton(
      onPressed: onPressed,
      label: label,
      iconPath: iconPath,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      isLoading: isLoading,
    );
  }
}
