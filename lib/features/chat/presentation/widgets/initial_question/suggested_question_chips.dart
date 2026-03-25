import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';

class SuggestedQuestionChips extends StatelessWidget {
  const SuggestedQuestionChips({
    super.key,
    required this.type,
    required this.isDark,
    required this.onTap,
  });

  final ClassicType type;
  final bool isDark;
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
          return GestureDetector(
            onTap: () => onTap(suggestion),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: GudaSpacing.md,
                vertical: GudaSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: (isDark
                        ? GudaColors.surfaceVariantDark
                        : GudaColors.surfaceVariantLight)
                    .withValues(alpha: 0.7),
                borderRadius: GudaRadius.fullAll,
                border: Border.all(
                  color: (isDark ? GudaColors.dividerDark : GudaColors.dividerLight)
                      .withValues(alpha: 0.5),
                ),
              ),
              child: Center(
                child: Text(
                  suggestion,
                  style: GudaTypography.caption(
                    color: isDark
                        ? GudaColors.onSurfaceDark
                        : GudaColors.onSurfaceLight,
                  ).copyWith(fontSize: 14),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
