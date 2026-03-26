import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

/// 하단 푸터 등에 사용되는 사각형 모양의 액션 아이콘 버튼
class GudaActionIconButton extends StatelessWidget {
  const GudaActionIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.padding = const EdgeInsets.all(GudaSpacing.md),
  });

  final VoidCallback onPressed;
  final IconData icon;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      padding: padding,
      style: IconButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: isDark
            ? GudaColors.onSurfaceVariantDark
            : GudaColors.onSurfaceVariantLight,
        shape: RoundedRectangleBorder(borderRadius: GudaRadius.mdAll),
      ),
    );
  }
}
