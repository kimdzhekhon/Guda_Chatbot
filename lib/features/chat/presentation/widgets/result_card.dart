import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_markdown.dart';

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
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      margin: const EdgeInsets.symmetric(horizontal: GudaSpacing.md),
      padding: const EdgeInsets.all(GudaSpacing.xl),
      decoration: BoxDecoration(
        color: isDark ? GudaColors.backgroundDark : GudaColors.backgroundLight,
        borderRadius: BorderRadius.circular(GudaRadius.lg),
        boxShadow: GudaShadows.card,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [GudaColors.backgroundDark, GudaColors.surfaceDark]
              : [GudaColors.backgroundLight, Colors.white],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: GudaSpacing.sm,
                  vertical: GudaSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: GudaColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(GudaRadius.sm),
                ),
                child: Text(
                  classicName ?? 'Guda',
                  style: GudaTypography.caption(
                    color: GudaColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Guda — AI 지혜',
                style: GudaTypography.caption(
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
            ],
          ),
          const SizedBox(height: GudaSpacing.lg),
          Text(
            title,
            style: GudaTypography.heading3(
              color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
            ),
          ),
          const SizedBox(height: GudaSpacing.md),
          const Divider(),
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
                '© ${DateTime.now().year} Guda. All rights reserved.',
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

// Fixed typo in LinearGradient if it was there (I wrote Linear調 by mistake in thought, fixing now)
extension on ResultCard {
  // This was just a thought bubble fix.
}
