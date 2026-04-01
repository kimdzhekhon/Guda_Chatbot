import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

/// Guda 공통 텍스트 입력 필드 컨테이너
/// 디자인 시스템에 따른 배경색, 곡률, 테두리를 적용합니다.
class GudaTextInputField extends StatelessWidget {
  const GudaTextInputField({
    super.key,
    required this.controller,
    this.hintText,
    this.maxLines = 1,
    this.autofocus = false,
    this.enabled = true,
    this.onSubmitted,
    this.style,
    this.hintStyle,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.contentPadding,
  });

  final TextEditingController controller;
  final String? hintText;
  final int? maxLines;
  final bool autofocus;
  final bool enabled;
  final ValueChanged<String>? onSubmitted;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final defaultBg = context.isDark ? GudaColors.surfaceVariantDark : GudaColors.surfaceVariantLight;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: borderRadius ?? GudaRadius.lgAll,
        border: border,
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        autofocus: autofocus,
        enabled: enabled,
        style: style ?? GudaTypography.input(color: colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: hintStyle ??
              GudaTypography.input(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
          fillColor: Colors.transparent,
          filled: true,
          border: InputBorder.none,
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(
                horizontal: GudaSpacing.md,
                vertical: GudaSpacing.md12,
              ),
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }
}
