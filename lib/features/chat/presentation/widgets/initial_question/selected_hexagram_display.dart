import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/features/chat/domain/entities/hexagram.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/hexagram_widgets.dart';

class SelectedHexagramDisplay extends StatelessWidget {
  const SelectedHexagramDisplay({
    super.key,
    required this.isDark,
    required this.hexagram,
    required this.onReset,
  });

  final bool isDark;
  final Hexagram hexagram;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(GudaSpacing.md),
      decoration: BoxDecoration(
        color:
            (isDark
                    ? GudaColors.surfaceVariantDark
                    : GudaColors.surfaceVariantLight)
                .withValues(alpha: 0.5),
        borderRadius: GudaRadius.smAll,
        border: Border.all(
          color: (isDark ? GudaColors.dividerDark : GudaColors.dividerLight)
              .withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          HexagramWidget(
            lines: hexagram.lines,
            size: 32,
            color: GudaColors.primary,
          ),
          const SizedBox(width: GudaSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      hexagram.name,
                      style: GudaTypography.body1(
                        color: isDark
                            ? GudaColors.onSurfaceDark
                            : GudaColors.onSurfaceLight,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: GudaSpacing.xs),
                    Text(
                      '(${hexagram.hanja})',
                      style: GudaTypography.caption(
                        color: (isDark
                            ? GudaColors.onSurfaceVariantDark
                            : GudaColors.onSurfaceVariantLight),
                      ),
                    ),
                  ],
                ),
                Text(
                  hexagram.summary,
                  style: GudaTypography.caption(
                    color: (isDark
                        ? GudaColors.onSurfaceVariantDark
                        : GudaColors.onSurfaceVariantLight),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onReset,
            icon: Icon(
              Icons.restart_alt_rounded,
              size: 20,
              color: GudaColors.primary.withValues(alpha: 0.6),
            ),
            tooltip: '다시 선택',
          ),
        ],
      ),
    );
  }
}
