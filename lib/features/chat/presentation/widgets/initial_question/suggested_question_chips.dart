import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_chip.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';

class SuggestedQuestionChips extends StatelessWidget {
  const SuggestedQuestionChips({
    super.key,
    required this.type,
    required this.onTap,
  });

  final ClassicType type;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    final suggestions = type == ClassicType.tripitaka
        ? AppStrings.tripitakaSuggestions
        : AppStrings.ichingSuggestions;

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.md),
        itemCount: suggestions.length,
        separatorBuilder: (context, index) => const SizedBox(width: GudaSpacing.sm),
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return GudaChip(
            label: suggestion,
            onTap: () => onTap(suggestion),
          );
        },
      ),
    );
  }
}
