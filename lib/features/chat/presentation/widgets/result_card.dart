import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_markdown.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_divider.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_card.dart';
import 'package:guda_chatbot/core/constants/app_assets.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.title,
    required this.content,
    this.classicName,
    this.isDark = false,
  });

  final String title;
  final String content;
  final String? classicName;
  final bool isDark;

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
                  color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: GudaSpacing.md),
          const GudaDivider(),
          const SizedBox(height: GudaSpacing.md),
          GudaMarkdown(
            data: content,
            isDark: isDark,
          ),
          const SizedBox(height: GudaSpacing.xl),
          Center(
            child: Opacity(
              opacity: 0.5,
              child: Text(
                '© ${DateTime.now().year} ${AppStrings.copyrightSuffix}',
                style: GudaTypography.caption(
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
