import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_button.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_text_input_field.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_action_layout.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/domain/entities/hexagram.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/initial_question/selected_hexagram_display.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/initial_question/suggested_question_chips.dart';

class InputPhaseView extends StatelessWidget {
  const InputPhaseView({
    super.key,
    required this.type,
    required this.controller,
    required this.selectedHexagram,
    required this.onStart,
    required this.onResetHexagram,
  });

  final ClassicType type;
  final TextEditingController controller;
  final Hexagram? selectedHexagram;
  final Function(String) onStart;
  final VoidCallback onResetHexagram;

  @override
  Widget build(BuildContext context) {
    return GudaActionLayout(
      title: type == ClassicType.tripitaka
          ? AppStrings.tripitakaName
          : AppStrings.initialQuestionTitle,
      subtitle: type == ClassicType.tripitaka
          ? AppStrings.tripitakaDetailedGuide
          : AppStrings.initialQuestionSubtitle,
      child: Column(
        children: [
          if (selectedHexagram != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.md),
              child: SelectedHexagramDisplay(
                hexagram: selectedHexagram!,
                onReset: onResetHexagram,
              ),
            ),
          if (selectedHexagram != null) const SizedBox(height: GudaSpacing.lg),
          if (type != ClassicType.tripitaka)
            Padding(
              padding: const EdgeInsets.only(bottom: GudaSpacing.md),
              child: SuggestedQuestionChips(
                type: type,
                onTap: (text) => controller.text = text,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.md),
            child: GudaTextInputField(
              controller: controller,
              autofocus: true,
              hintText: type == ClassicType.tripitaka
                  ? AppStrings.tripitakaQuestionHint
                  : AppStrings.initialQuestionHint,
            ),
          ),
          const SizedBox(height: GudaSpacing.lg),
          GudaButton.filled(
            label: type == ClassicType.tripitaka
                ? AppStrings.tripitakaStartButton
                : AppStrings.startDivinationButton,
            onPressed: () => onStart(controller.text),
            isFullWidth: true,
          ),
        ],
      ),
    );
  }
}
