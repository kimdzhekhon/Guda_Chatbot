import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// Guda 공통 텍스트 입력 필드
class GudaTextField extends StatelessWidget {
  const GudaTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.onSubmitted,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.suffixIcon,
    this.prefixIcon,
    this.autofocus = false,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool autofocus;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      autofocus: autofocus,
      enabled: enabled,
      style: GudaTypography.input(color: colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        hintStyle: GudaTypography.input(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: GudaRadius.mdAll,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: GudaRadius.mdAll,
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: GudaSpacing.md,
          vertical: GudaSpacing.md12,
        ),
      ),
    );
  }
}
