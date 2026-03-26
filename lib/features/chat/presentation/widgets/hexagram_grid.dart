import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_empty_view.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';
import 'package:guda_chatbot/features/chat/domain/entities/hexagram.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/hexagram_widgets.dart';

class HexagramGrid extends StatelessWidget {
  const HexagramGrid({
    super.key,
    required this.hexagrams,
    required this.onHexagramSelected,
    this.padding,
  });

  final List<Hexagram> hexagrams;
  final Function(Hexagram) onHexagramSelected;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (hexagrams.isEmpty) {
      return const GudaEmptyView(
        message: '검색 결과가 없습니다.',
        icon: Icons.search_off_rounded,
      );
    }

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return GridView.builder(
      padding: padding ??
          EdgeInsets.only(
            top: GudaSpacing.md,
            left: GudaSpacing.md,
            right: GudaSpacing.md,
            bottom: bottomPadding + GudaSpacing.lg,
          ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
        crossAxisSpacing: GudaSpacing.md,
        mainAxisSpacing: GudaSpacing.lg,
      ),
      itemCount: hexagrams.length,
      itemBuilder: (context, index) {
        final hexagram = hexagrams[index];
        return _HexagramItem(
          hexagram: hexagram,
          onTap: () => onHexagramSelected(hexagram),
        );
      },
    );
  }
}

class _HexagramItem extends StatelessWidget {
  final Hexagram hexagram;
  final VoidCallback onTap;

  const _HexagramItem({required this.hexagram, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: GudaRadius.mdAll,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HexagramWidget(
            lines: hexagram.lines,
            size: 48,
          ),
          const SizedBox(height: GudaSpacing.sm),
          Text(
            hexagram.name
                .replaceAll('중', '')
                .replaceAll('천', '')
                .replaceAll('지', ''),
            textAlign: TextAlign.center,
            style: GudaTypography.captionSemiBold(
              color: context.onSurfaceColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            hexagram.hanja,
            style: GudaTypography.tiny(
              color: context.onSurfaceVariantColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
