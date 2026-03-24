import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/domain/entities/hexagram.dart';
import 'package:guda_chatbot/features/chat/domain/constants/hexagram_data.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/hexagram_selection_bottom_sheet.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/hexagram_widgets.dart';

enum CardPhase {
  selection,   // 궤 선택/던지기 선택 단계
  animating,   // 궤 던지는 애니메이션 단계
  input,       // 질문 입력 단계
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
    _phase = widget.type == ClassicType.tripitaka ? CardPhase.input : CardPhase.selection;
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
        final pickedHexagram = hexagramData[random.nextInt(hexagramData.length)];
        
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

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      margin: const EdgeInsets.symmetric(horizontal: GudaSpacing.lg),
      padding: const EdgeInsets.all(GudaSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? GudaColors.surfaceDark : GudaColors.surfaceLight,
        borderRadius: GudaRadius.lgAll,
        boxShadow: GudaShadows.card,
        border: Border.all(
          color: (isDark ? GudaColors.dividerDark : GudaColors.dividerLight).withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: _buildContent(isDark),
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    return switch (_phase) {
      CardPhase.selection => _buildSelectionView(isDark),
      CardPhase.animating => _buildAnimationView(isDark),
      CardPhase.input => _buildInputView(isDark),
    };
  }

  Widget _buildSelectionView(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: GudaSpacing.md),
        Text(
          widget.type == ClassicType.tripitaka 
              ? AppStrings.tripitakaInitialTitle 
              : AppStrings.ichingSelectionTitle,
          style: GudaTypography.heading3(
            color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: GudaSpacing.lg),
        Row(
          children: [
            Expanded(
              child: _SelectionBox(
                label: AppStrings.selectHexagram,
                icon: Icons.grid_view_rounded,
                onTap: _handleSelect,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: GudaSpacing.md),
            Expanded(
              child: _SelectionBox(
                label: AppStrings.throwHexagram,
                icon: Icons.casino_outlined,
                onTap: _handleThrow,
                isDark: isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: GudaSpacing.lg),
      ],
    );
  }

  Widget _buildAnimationView(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: GudaSpacing.md),
        SizedBox(
          height: 150,
          child: Lottie.asset(
            'assets/lottie/Dice Roll Purple.json',
            repeat: false,
          ),
        ),
        const SizedBox(height: GudaSpacing.md),
        Text(
          '괘를 던지는 중입니다...',
          style: GudaTypography.body1(
            color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
          ),
        ),
        const SizedBox(height: GudaSpacing.md),
      ],
    );
  }

  Widget _buildInputView(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: GudaSpacing.md),
        Text(
          widget.type == ClassicType.tripitaka ? AppStrings.tripitakaName : AppStrings.initialQuestionTitle,
          style: GudaTypography.heading3(
            color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
          ).copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: GudaSpacing.lg),
        Text(
          widget.type == ClassicType.tripitaka 
              ? '고려대장경의 불교 경전에 대해 질문해보세요. 금강경, 반야심경,\n법화경 등 다양한 경전에 대해 대화할 수 있습니다.'
              : AppStrings.initialQuestionSubtitle,
          style: GudaTypography.body2(
            color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: GudaSpacing.lg),
        if (_selectedHexagram != null) _buildSelectedHexagramDisplay(isDark),
        if (_selectedHexagram != null) const SizedBox(height: GudaSpacing.lg),
        Container(
          decoration: BoxDecoration(
            color: isDark ? GudaColors.backgroundDark : GudaColors.backgroundLight,
            borderRadius: GudaRadius.smAll,
            border: Border.all(
              color: isDark ? GudaColors.dividerDark : GudaColors.dividerLight,
            ),
          ),
          child: TextField(
            controller: _controller,
            autofocus: true,
            style: GudaTypography.input(
              color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
            ),
            decoration: InputDecoration(
              hintText: widget.type == ClassicType.tripitaka 
                  ? '경전에 대해 궁금한 점을 적어주세요' 
                  : AppStrings.initialQuestionHint,
              hintStyle: GudaTypography.input(
                color: (isDark ? GudaColors.onSurfaceVariantDark : GudaColors.onSurfaceVariantLight).withValues(alpha: 0.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: GudaSpacing.md,
                vertical: GudaSpacing.md,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: GudaSpacing.lg),
        ElevatedButton(
          onPressed: () => widget.onStart(_controller.text),
          style: ElevatedButton.styleFrom(
            backgroundColor: GudaColors.primary,
            foregroundColor: GudaColors.onUserBubble,
            padding: const EdgeInsets.symmetric(vertical: GudaSpacing.md),
            shape: const RoundedRectangleBorder(
              borderRadius: GudaRadius.smAll,
            ),
            elevation: 0,
          ),
          child: Text(
            widget.type == ClassicType.tripitaka ? '대화 시작하기' : AppStrings.startDivinationButton,
            style: GudaTypography.button(),
          ),
        ),
        const SizedBox(height: GudaSpacing.md),
      ],
    );
  }

  Widget _buildSelectedHexagramDisplay(bool isDark) {
    if (_selectedHexagram == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(GudaSpacing.md),
      decoration: BoxDecoration(
        color: (isDark ? GudaColors.surfaceVariantDark : GudaColors.surfaceVariantLight).withValues(alpha: 0.5),
        borderRadius: GudaRadius.mdAll,
        border: Border.all(
          color: (isDark ? GudaColors.dividerDark : GudaColors.dividerLight).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          HexagramWidget(
            lines: _selectedHexagram!.lines,
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
                      _selectedHexagram!.name,
                      style: GudaTypography.body1(
                        color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: GudaSpacing.xs),
                    Text(
                      '(${_selectedHexagram!.hanja})',
                      style: GudaTypography.caption(
                        color: (isDark ? GudaColors.onSurfaceVariantDark : GudaColors.onSurfaceVariantLight),
                      ),
                    ),
                  ],
                ),
                Text(
                  _selectedHexagram!.summary,
                  style: GudaTypography.caption(
                    color: (isDark ? GudaColors.onSurfaceVariantDark : GudaColors.onSurfaceVariantLight),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedHexagram = null;
                _phase = CardPhase.selection;
              });
            },
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
          color: isDark ? GudaColors.surfaceVariantDark : GudaColors.surfaceVariantLight,
          borderRadius: GudaRadius.mdAll,
          border: Border.all(
            color: (isDark ? GudaColors.dividerDark : GudaColors.dividerLight).withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: GudaColors.primary,
            ),
            const SizedBox(height: GudaSpacing.sm),
            Text(
              label,
              style: GudaTypography.button(
                color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
