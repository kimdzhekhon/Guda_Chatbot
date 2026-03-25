import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_selection_box.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_action_layout.dart';

class SelectionPhaseView extends StatelessWidget {
  const SelectionPhaseView({
    super.key,
    required this.type,
    required this.isDark,
    required this.onSelect,
    required this.onThrow,
  });

  final ClassicType type;
  final bool isDark;
  final VoidCallback onSelect;
  final VoidCallback onThrow;

  @override
  Widget build(BuildContext context) {
    return GudaActionLayout(
      isDark: isDark,
      title: type == ClassicType.tripitaka
          ? AppStrings.tripitakaInitialTitle
          : AppStrings.ichingSelectionTitle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: GudaSelectionBox(
                label: AppStrings.selectHexagram,
                icon: Icons.grid_view_rounded,
                onTap: onSelect,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: GudaSpacing.md),
            Expanded(
              child: GudaSelectionBox(
                label: AppStrings.throwHexagram,
                icon: Icons.casino_outlined,
                onTap: onThrow,
                isDark: isDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
