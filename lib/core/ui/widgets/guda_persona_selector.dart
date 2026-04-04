import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/features/chat/domain/entities/persona_type.dart';

/// 페르소나 선택 항목 데이터
class PersonaSelectorItem {
  const PersonaSelectorItem({
    required this.id,
    required this.label,
  });

  final PersonaType id;
  final String label;
}

/// Guda 공통 페르소나 선택 위젯
/// 온보딩과 설정 화면에서 재사용됩니다.
class GudaPersonaSelector extends StatelessWidget {
  const GudaPersonaSelector({
    super.key,
    required this.items,
    required this.selectedId,
    required this.onSelected,
    this.isDarkBackground = false,
  });

  final List<PersonaSelectorItem> items;
  final PersonaType selectedId;
  final ValueChanged<PersonaType> onSelected;

  /// true이면 어두운 배경(온보딩) 스타일, false이면 밝은 배경(설정) 스타일
  final bool isDarkBackground;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: GudaSpacing.md12),
          _buildItem(context, items[i]),
        ],
      ],
    );
  }

  Widget _buildItem(BuildContext context, PersonaSelectorItem item) {
    final isSelected = item.id == selectedId;

    return GestureDetector(
      onTap: () => onSelected(item.id),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: GudaSpacing.md,
          vertical: GudaSpacing.md12,
        ),
        decoration: BoxDecoration(
          color: isDarkBackground
              ? Colors.white.withValues(alpha: isSelected ? 0.15 : 0.08)
              : (isSelected
                  ? GudaColors.primary.withValues(alpha: 0.08)
                  : Theme.of(context).colorScheme.surfaceContainerLow),
          borderRadius: GudaRadius.lgAll,
          border: Border.all(
            color: isSelected
                ? GudaColors.primary
                : (isDarkBackground ? Colors.white24 : Theme.of(context).colorScheme.outlineVariant),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected
                  ? GudaColors.primary
                  : (isDarkBackground ? Colors.white38 : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
              size: 20,
            ),
            const SizedBox(width: GudaSpacing.sm),
            Text(
              item.label,
              style: isSelected
                  ? GudaTypography.body1Bold(
                      color: isDarkBackground ? Colors.white : Theme.of(context).colorScheme.onSurface,
                    )
                  : GudaTypography.body1(
                      color: isDarkBackground ? Colors.white70 : Theme.of(context).colorScheme.onSurface,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
