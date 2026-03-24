import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/constants/app_assets.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_animations.dart';

/// Guda 공통 브랜드 헤더 위젯
/// 앱 로고와 타이틀("Guda")을 일관되게 표시하며, 여러 크기를 지원합니다.
class GudaBrandHeader extends StatelessWidget {
  const GudaBrandHeader({
    super.key,
    this.isLarge = true,
    this.color = Colors.white,
    this.title = AppStrings.brandName,
    this.subtitle,
    this.showLogo = true,
  });

  final bool isLarge;
  final Color color;
  final String title;
  final String? subtitle;
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLogo)
          Image.asset(
            AppAssets.appLogoTransparent,
            width: isLarge ? 120 : 28,
            height: isLarge ? 120 : 28,
          ).gudaScaleIn(
            duration: const Duration(milliseconds: 700),
            curve: Curves.elasticOut,
          ),
        const SizedBox(height: GudaSpacing.sm),
        Text(
          title,
          style: isLarge
              ? GudaTypography.brand(color: color)
              : GudaTypography.labelSmall(color: color),
        ).gudaFadeIn(delay: const Duration(milliseconds: 200)),
        if (subtitle != null) ...[
          const SizedBox(height: GudaSpacing.sm),
          Text(
            subtitle!,
            style: GudaTypography.body2(
              color: color.withValues(alpha: 0.75),
            ),
          ).gudaFadeIn(delay: const Duration(milliseconds: 350)),
        ],
      ],
    );
  }
}
