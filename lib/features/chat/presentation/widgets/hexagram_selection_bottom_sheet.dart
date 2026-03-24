import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/features/chat/domain/entities/hexagram.dart';
import 'package:guda_chatbot/features/chat/domain/constants/hexagram_data.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/hexagram_widgets.dart';

/// 64괘 선택 바텀 시트
class HexagramSelectionBottomSheet extends StatelessWidget {
  final Function(Hexagram) onHexagramSelected;

  const HexagramSelectionBottomSheet({
    super.key,
    required this.onHexagramSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7, // 화면의 70% 높이
      decoration: BoxDecoration(
        color: isDark ? GudaColors.surfaceDark : GudaColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // 드래그 핸들
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: (isDark
                  ? GudaColors.dividerDark
                  : GudaColors.dividerLight),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // 헤더
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '괘 선택',
                  style: GudaTypography.heading2(
                    color: isDark
                        ? GudaColors.onSurfaceDark
                        : GudaColors.onSurfaceLight,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close_rounded,
                    color: isDark
                        ? GudaColors.onSurfaceVariantDark
                        : GudaColors.onSurfaceVariantLight,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 32),

          // 64괘 그리드
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.only(
                left: GudaSpacing.md,
                right: GudaSpacing.md,
                bottom: bottomPadding + GudaSpacing.lg,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 1줄에 4개
                childAspectRatio: 0.8, // 세로로 약간 긴 형태 (이미지 + 텍스트)
                crossAxisSpacing: GudaSpacing.md,
                mainAxisSpacing: GudaSpacing.lg,
              ),
              itemCount: hexagramData.length,
              itemBuilder: (context, index) {
                final hexagram = hexagramData[index];
                return _HexagramItem(
                  hexagram: hexagram,
                  onTap: () {
                    onHexagramSelected(hexagram);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HexagramItem extends StatelessWidget {
  final Hexagram hexagram;
  final VoidCallback onTap;

  const _HexagramItem({required this.hexagram, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: GudaRadius.mdAll,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HexagramWidget(
            lines: hexagram.lines,
            size: 48,
            color: GudaColors.primary,
          ),
          const SizedBox(height: GudaSpacing.sm),
          Text(
            hexagram.name
                .replaceAll('중', '')
                .replaceAll('천', '')
                .replaceAll('지', ''), // 간략화된 이름 표시 (선택사항)
            // 하지만 사용자가 "궤 이름"이 나오게 해달라고 했으므로 전체 이름을 적절히 표시
            // 너무 길면 줄바꿈 처리
            textAlign: TextAlign.center,
            style: GudaTypography.caption(
              color: isDark
                  ? GudaColors.onSurfaceDark
                  : GudaColors.onSurfaceLight,
            ).copyWith(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            hexagram.hanja,
            style: GudaTypography.caption(
              color:
                  (isDark
                          ? GudaColors.onSurfaceVariantDark
                          : GudaColors.onSurfaceVariantLight)
                      .withValues(alpha: 0.7),
            ).copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
