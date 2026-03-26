import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

/// Guda 공통 토글/세그먼트 컨트롤 위젯
/// 두 개 이상의 옵션 중 하나를 선택할 때 사용하며, 애니메이션 전환 효과를 제공합니다.
class GudaToggleControl<T> extends StatelessWidget {
  const GudaToggleControl({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  final List<GudaToggleOption<T>> options;
  final T selectedValue;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      padding: const EdgeInsets.all(GudaSpacing.xs),
      decoration: BoxDecoration(
        color: isDark ? GudaColors.surfaceVariantDark : GudaColors.surfaceVariantLight,
        borderRadius: GudaRadius.fullAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          final isSelected = option.value == selectedValue;
          return _ToggleItem(
            title: option.label,
            isSelected: isSelected,
            onTap: () => onChanged(option.value),
          );
        }).toList(),
      ),
    );
  }
}

class GudaToggleOption<T> {
  final String label;
  final T value;

  const GudaToggleOption({
    required this.label,
    required this.value,
  });
}

class _ToggleItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: GudaSpacing.lg,
          vertical: GudaSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? GudaColors.primaryLight : GudaColors.primary)
              : Colors.transparent,
          borderRadius: GudaRadius.fullAll,
          boxShadow: isSelected ? GudaShadows.bubble : null,
        ),
        child: Text(
          title,
          style: GudaTypography.captionBold(
            color: isSelected
                ? Colors.white
                : (isDark
                    ? GudaColors.onSurfaceVariantDark
                    : GudaColors.onSurfaceVariantLight),
          ),
        ),
      ),
    );
  }
}
