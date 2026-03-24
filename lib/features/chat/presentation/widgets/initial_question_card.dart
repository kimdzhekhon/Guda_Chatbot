import 'dart:math';
import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_card.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/domain/entities/hexagram.dart';
import 'package:guda_chatbot/features/chat/domain/constants/hexagram_data.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/hexagram_selection_bottom_sheet.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/initial_question/animation_phase_view.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/initial_question/input_phase_view.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/initial_question/selection_phase_view.dart';

enum CardPhase {
  selection, // 궤 선택/던지기 선택 단계
  animating, // 궤 던지는 애니메이션 단계
  input, // 질문 입력 단계
}

class InitialQuestionCard extends StatefulWidget {
  final VoidCallback onSkip;
  final Function(String) onStart;
  final ClassicType type;

  const InitialQuestionCard({
    super.key,
    required this.onSkip,
    required this.onStart,
    required this.type,
  });

  @override
  State<InitialQuestionCard> createState() => _InitialQuestionCardState();
}

class _InitialQuestionCardState extends State<InitialQuestionCard> {
  late CardPhase _phase;
  final _controller = TextEditingController();
  Hexagram? _selectedHexagram;

  @override
  void initState() {
    super.initState();
    // 팔만대장경은 궤 선택 단계 없이 입력창으로 시작
    _phase = widget.type == ClassicType.tripitaka
        ? CardPhase.input
        : CardPhase.selection;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleThrow() {
    setState(() {
      _phase = CardPhase.animating;
    });

    // 애니메이션 종료 후 입력 단계로 전환
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        final random = Random();
        final pickedHexagram =
            hexagramData[random.nextInt(hexagramData.length)];

        setState(() {
          _selectedHexagram = pickedHexagram;
          _phase = CardPhase.input;
        });
      }
    });
  }

  void _handleSelect() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HexagramSelectionBottomSheet(
        onHexagramSelected: (hexagram) {
          setState(() {
            _selectedHexagram = hexagram;
            _phase = CardPhase.input;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GudaCard(
      constraints: const BoxConstraints(maxWidth: 400),
      margin: const EdgeInsets.symmetric(horizontal: GudaSpacing.lg),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: _buildContent(isDark),
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    return switch (_phase) {
      CardPhase.selection => SelectionPhaseView(
          type: widget.type,
          isDark: isDark,
          onSelect: _handleSelect,
          onThrow: _handleThrow,
        ),
      CardPhase.animating => AnimationPhaseView(isDark: isDark),
      CardPhase.input => InputPhaseView(
          type: widget.type,
          isDark: isDark,
          controller: _controller,
          selectedHexagram: _selectedHexagram,
          onStart: widget.onStart,
          onResetHexagram: () {
            setState(() {
              _selectedHexagram = null;
              _phase = CardPhase.selection;
            });
          },
        ),
    };
  }
}
