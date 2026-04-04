import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_divider.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_bottom_sheet.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_bottom_sheet_header.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_text_input_field.dart';
import 'package:guda_chatbot/features/chat/domain/entities/hexagram.dart';
import 'package:guda_chatbot/features/chat/domain/constants/hexagram_data.dart';

import 'package:guda_chatbot/features/chat/presentation/widgets/hexagram_grid.dart';

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
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    // 200ms 디바운싱: 빠른 타이핑 시 불필요한 필터링/리빌드 방지
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text.trim();
        });
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredHexagrams = _searchQuery.isEmpty
        ? hexagramData
        : hexagramData.where((hexagram) {
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.md),
            child: GudaTextInputField(
              controller: _searchController,
              hintText: '괘 이름이나 한자를 검색해보세요',
            ),
          ),
          const SizedBox(height: GudaSpacing.md),
          const GudaDivider(),
          Expanded(
            child: HexagramGrid(
              hexagrams: filteredHexagrams,
              onHexagramSelected: (hexagram) {
                widget.onHexagramSelected(hexagram);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
