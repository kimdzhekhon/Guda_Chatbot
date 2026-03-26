import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';
import 'package:guda_chatbot/core/constants/app_assets.dart';

/// Guda 봇 아바타 위젯
class GudaBotAvatar extends StatelessWidget {
  const GudaBotAvatar({
    super.key,
    this.radius = 16,
    this.padding = const EdgeInsets.all(GudaSpacing.xs),
  });

  final double radius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return CircleAvatar(
      radius: radius,
      backgroundColor: isDark ? GudaColors.surfaceDark : GudaColors.surfaceLight,
      child: Padding(
        padding: padding,
        child: Image.asset(AppAssets.appLogoTransparent),
      ),
    );
  }
}
