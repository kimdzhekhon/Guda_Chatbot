import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

class AnimationPhaseView extends StatelessWidget {
  const AnimationPhaseView({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
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
            color: isDark
                ? GudaColors.onSurfaceDark
                : GudaColors.onSurfaceLight,
          ),
        ),
        const SizedBox(height: GudaSpacing.md),
      ],
    );
  }
}
