import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_button.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

class ClassicStartButton extends StatelessWidget {
  const ClassicStartButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.xl),
      child: GudaButton.filled(
        label: isLoading ? '대화 생성 중...' : '새 대화 시작',
        onPressed: onPressed,
        icon: isLoading ? null : Icons.chat_bubble_outline,
        isLoading: isLoading,
        isFullWidth: true,
        backgroundColor: context.isDark ? GudaColors.accent : null,
        foregroundColor: context.isDark ? context.colorScheme.onPrimary : null,
      ),
    );
  }
}
