import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/classic_card.dart';

class ClassicCardPageView extends StatelessWidget {
  const ClassicCardPageView({
    super.key,
    required this.controller,
    required this.onPageChanged,
    this.isLoading = false,
  });

  final PageController controller;
  final ValueChanged<int> onPageChanged;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      onPageChanged: onPageChanged,
      physics: isLoading ? const NeverScrollableScrollPhysics() : null,
      children: [
        ClassicCard(
          type: ClassicType.tripitaka,
          title: AppStrings.tripitakaName,
          description: AppStrings.tripitakaDesc,
          contentsSubtitle: AppStrings.tripitakaContentsSubtitle,
          contents: const [
            AppStrings.tripitakaContents1,
            AppStrings.tripitakaContents2,
            AppStrings.tripitakaContents3,
          ],
        ),
        ClassicCard(
          type: ClassicType.iching,
          title: AppStrings.ichingName,
          description: AppStrings.ichingDesc,
          contentsSubtitle: AppStrings.ichingContentsSubtitle,
          contents: const [
            AppStrings.ichingContents1,
            AppStrings.ichingContents2,
          ],
        ),
      ],
    );
  }
}
