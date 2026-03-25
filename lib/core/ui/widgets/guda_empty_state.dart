import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_lottie.dart';

class GudaEmptyState extends StatelessWidget {
  const GudaEmptyState({
    super.key,
    this.icon,
    this.lottiePath,
    this.lottieSize = 120,
    required this.title,
    this.subtitle,
    this.action,
  });

  final IconData? icon;
  final String? lottiePath;
  final double lottieSize;
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(GudaSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (lottiePath != null) ...[
              GudaLottie(
                path: lottiePath!,
                size: lottieSize,
              ),
              const SizedBox(height: GudaSpacing.md),
            ] else if (icon != null) ...[
              Icon(
                icon,
                size: 64,
                color: (isDark
                        ? GudaColors.onSurfaceVariantDark
                        : GudaColors.onSurfaceVariantLight)
                    .withValues(alpha: 0.3),
              ),
              const SizedBox(height: GudaSpacing.lg),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: GudaTypography.heading3(
                color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: GudaSpacing.sm),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: GudaTypography.body2(
                  color: isDark ? GudaColors.onSurfaceVariantDark : GudaColors.onSurfaceVariantLight,
                ),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: GudaSpacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
