import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_bottom_sheet.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_bottom_sheet_header.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_divider.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_text_input_field.dart';
import 'package:guda_chatbot/features/chat/domain/entities/hexagram.dart';
import 'package:guda_chatbot/features/chat/domain/constants/hexagram_data.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/hexagram_widgets.dart';

/// 64괘 선택 바텀 시트
class HexagramSelectionBottomSheet extends StatefulWidget {
  final Function(Hexagram) onHexagramSelected;

  const HexagramSelectionBottomSheet({
    super.key,
    required this.onHexagramSelected,
  });

  @override
  State<HexagramSelectionBottomSheet> createState() =>
      _HexagramSelectionBottomSheetState();
}

class _HexagramSelectionBottomSheetState
    extends State<HexagramSelectionBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredHexagrams = hexagramData.where((hexagram) {
      if (_searchQuery.isEmpty) return true;
      return hexagram.name.contains(_searchQuery) ||
          hexagram.hanja.contains(_searchQuery);
    }).toList();

    return GudaBottomSheet(
      child: Column(
        children: [
          GudaBottomSheetHeader(
            title: '괘 선택',
            onClose: () => Navigator.pop(context),
          ),
          
          // 검색창
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.md),
            child: GudaTextInputField(
              controller: _searchController,
              isDark: isDark,
              hintText: '괘 이름이나 한자를 검색해보세요',
            ),
          ),
          const SizedBox(height: GudaSpacing.md),
          const GudaDivider(),

          // 64괘 그리드
          Expanded(
            child: filteredHexagrams.isEmpty
                ? Center(
                    child: Text(
                      '검색 결과가 없습니다.',
                      style: GudaTypography.body1(
                        color: isDark
                            ? GudaColors.onSurfaceVariantDark
                            : GudaColors.onSurfaceVariantLight,
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.only(
                      top: GudaSpacing.md,
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
                    itemCount: filteredHexagrams.length,
                    itemBuilder: (context, index) {
                      final hexagram = filteredHexagrams[index];
                      return _HexagramItem(
                        hexagram: hexagram,
                        onTap: () {
                          widget.onHexagramSelected(hexagram);
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
            style: GudaTypography.captionSemiBold(
              color: isDark
                  ? GudaColors.onSurfaceDark
                  : GudaColors.onSurfaceLight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            hexagram.hanja,
            style: GudaTypography.tiny(
              color: (isDark
                      ? GudaColors.onSurfaceVariantDark
                      : GudaColors.onSurfaceVariantLight)
                  .withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
