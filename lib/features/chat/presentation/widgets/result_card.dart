import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_markdown.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_divider.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_card.dart';
import 'package:guda_chatbot/core/constants/app_assets.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_copyright.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.title,
    required this.content,
    this.classicName,
  });

  final String title;
  final String content;
  final String? classicName;

  @override
  Widget build(BuildContext context) {
    return GudaCard(
      padding: const EdgeInsets.all(GudaSpacing.xl),
      boxShadow: GudaShadows.bubble,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                AppAssets.tripitakaImage,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: GudaSpacing.sm),
              Text(
                title,
                style: GudaTypography.body1Bold(
                  color: context.onSurfaceColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: GudaSpacing.md),
          const GudaDivider(),
          const SizedBox(height: GudaSpacing.md),
          GudaMarkdown(
            data: content,
          ),
          const SizedBox(height: GudaSpacing.xl),
          const GudaCopyright(),
        ],
      ),
    );
  }
}
