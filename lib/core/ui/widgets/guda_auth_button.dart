import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_button.dart';

/// 인증 화면 전용 버튼 컴포넌트
/// GudaButton.filled를 기반으로 하여 일관된 디자인 시스템을 적용합니다.
class GudaAuthButton extends StatelessWidget {
  const GudaAuthButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
    this.height = 47,
  });

  final VoidCallback? onPressed;
  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: GudaButton.filled(
        label: label,
        onPressed: onPressed ?? () {},
        isLoading: isLoading,
        isFullWidth: true,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
    );
  }
}
