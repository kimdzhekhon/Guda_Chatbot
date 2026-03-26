import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// 인증 화면 전용 텍스트 필드 컴포넌트
/// 56px 고정 높이, Outlined 스타일, 수직 중앙 정렬이 적용되어 있습니다.
class GudaAuthField extends StatelessWidget {
  const GudaAuthField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onSubmitted,
    this.textInputAction = TextInputAction.next,
  });

  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textAlignVertical: TextAlignVertical.center,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: GudaSpacing.md,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: GudaRadius.mdAll,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: GudaRadius.mdAll,
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: GudaRadius.mdAll,
            borderSide: BorderSide(
              color: GudaColors.primary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
