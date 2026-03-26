import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_lottie.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_action_layout.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';

class AnimationPhaseView extends StatelessWidget {
  const AnimationPhaseView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const GudaActionLayout(
      title: AppStrings.ichingThrowingMsg,
      child: Center(
        child: GudaLottie(
          path: 'assets/lottie/Dice Roll Purple.json',
          size: 150,
        ),
      ),
    );
  }
}
