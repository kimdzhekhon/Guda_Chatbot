import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_button.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_text_input_field.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/domain/entities/hexagram.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/initial_question/selected_hexagram_display.dart';

class InputPhaseView extends StatelessWidget {
  const InputPhaseView({
    super.key,
    required this.type,
    required this.isDark,
    required this.controller,
    required this.selectedHexagram,
    required this.onStart,
    required this.onResetHexagram,
  });

  final ClassicType type;
  final bool isDark;
  final TextEditingController controller;
  final Hexagram? selectedHexagram;
  final Function(String) onStart;
  final VoidCallback onResetHexagram;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: GudaSpacing.md),
        Text(
          type == ClassicType.tripitaka
              ? AppStrings.tripitakaName
              : AppStrings.initialQuestionTitle,
          style: GudaTypography.heading3(
            color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
          ).copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: GudaSpacing.lg),
        Text(
          type == ClassicType.tripitaka
              ? '고려대장경의 불교 경전에 대해 질문해보세요. 금강경, 반야심경,\n법화경 등 다양한 경전에 대해 대화할 수 있습니다.'
              : AppStrings.initialQuestionSubtitle,
          style: GudaTypography.body2(
            color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: GudaSpacing.lg),
        if (selectedHexagram != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.md),
            child: SelectedHexagramDisplay(
              isDark: isDark,
              hexagram: selectedHexagram!,
              onReset: onResetHexagram,
            ),
          ),
        if (selectedHexagram != null) const SizedBox(height: GudaSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.md),
          child: GudaTextInputField(
            controller: controller,
            isDark: isDark,
            autofocus: true,
            hintText: type == ClassicType.tripitaka
                ? '경전에 대해 궁금한 점을 적어주세요'
                : AppStrings.initialQuestionHint,
            backgroundColor:
                isDark ? GudaColors.backgroundDark : GudaColors.backgroundLight,
            borderRadius: GudaRadius.smAll,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: GudaSpacing.md,
              vertical: GudaSpacing.md,
            ),
            style: GudaTypography.input(
              color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
            ),
          ),
        ),
        const SizedBox(height: GudaSpacing.lg),
        GudaButton.filled(
          label: type == ClassicType.tripitaka
              ? '대화 시작하기'
              : AppStrings.startDivinationButton,
          onPressed: () => onStart(controller.text),
          isFullWidth: true,
        ),
        const SizedBox(height: GudaSpacing.md),
      ],
    );
  }
}
