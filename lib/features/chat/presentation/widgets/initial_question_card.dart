import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_card.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/domain/constants/hexagram_data.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/home_viewmodel.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/hexagram_selection_bottom_sheet.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/initial_question/animation_phase_view.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/initial_question/input_phase_view.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/initial_question/selection_phase_view.dart';

class InitialQuestionCard extends ConsumerStatefulWidget {
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
  ConsumerState<InitialQuestionCard> createState() => _InitialQuestionCardState();
}

class _InitialQuestionCardState extends ConsumerState<InitialQuestionCard> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final activeId = ref.read(homeViewModelProvider).activeConversationId;
      // 새 대화(mock ID)인 경우에만 초기 단계로 리셋
      if (activeId == null || activeId.startsWith('mock-new-')) {
        ref.read(homeViewModelProvider.notifier).resetInitialPhase();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleThrow() {
    ref.read(homeViewModelProvider.notifier).updatePhase(CardPhase.animating);

    // 애니메이션 종료 후 입력 단계로 전환
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        final random = Random();
        final pickedHexagram = hexagramData[random.nextInt(hexagramData.length)];
        ref.read(homeViewModelProvider.notifier).selectHexagram(pickedHexagram);
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
          ref.read(homeViewModelProvider.notifier).selectHexagram(hexagram);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);

    return GudaCard(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: _buildContent(homeState),
      ),
    );
  }

  Widget _buildContent(HomeState homeState) {
    return switch (homeState.phase) {
      CardPhase.selection => SelectionPhaseView(
          type: widget.type,
          onSelect: _handleSelect,
          onThrow: _handleThrow,
        ),
      CardPhase.animating => const AnimationPhaseView(),
      CardPhase.input => InputPhaseView(
          type: widget.type,
          controller: _controller,
          selectedHexagram: homeState.selectedHexagram,
          onStart: widget.onStart,
          onResetHexagram: () {
            ref.read(homeViewModelProvider.notifier).resetInitialPhase();
          },
        ),
    };
  }
}
