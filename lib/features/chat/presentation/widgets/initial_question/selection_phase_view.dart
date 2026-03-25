import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: GudaSpacing.md),
        Text(
          type == ClassicType.tripitaka
              ? AppStrings.tripitakaInitialTitle
              : AppStrings.ichingSelectionTitle,
          style: GudaTypography.heading3(
            color: isDark
                ? GudaColors.onSurfaceDark
                : GudaColors.onSurfaceLight,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: GudaSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: _SelectionBox(
                  label: AppStrings.selectHexagram,
                  icon: Icons.grid_view_rounded,
                  onTap: onSelect,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: GudaSpacing.md),
              Expanded(
                child: _SelectionBox(
                  label: AppStrings.throwHexagram,
                  icon: Icons.casino_outlined,
                  onTap: onThrow,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: GudaSpacing.lg),
      ],
    );
  }
}

class _SelectionBox extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _SelectionBox({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: GudaRadius.mdAll,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: GudaSpacing.lg),
        decoration: BoxDecoration(
          color: isDark
              ? GudaColors.surfaceVariantDark
              : GudaColors.surfaceVariantLight,
          borderRadius: GudaRadius.mdAll,
          border: Border.all(
            color: (isDark ? GudaColors.dividerDark : GudaColors.dividerLight)
                .withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: GudaColors.primary),
            const SizedBox(height: GudaSpacing.sm),
            Text(
              label,
              style: GudaTypography.button(
                color: isDark
                    ? GudaColors.onSurfaceDark
                    : GudaColors.onSurfaceLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
