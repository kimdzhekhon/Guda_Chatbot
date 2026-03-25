import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/constants/app_assets.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_bullet_list.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_divider.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_card.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';

/// 고전 유형(팔만대장경, 주역)의 정보를 시각적으로 보여주는 카드 위젯
class ClassicCard extends StatelessWidget {
  const ClassicCard({
    super.key,
    required this.type,
    required this.title,
    required this.description,
    required this.contentsSubtitle,
    required this.contents,
  });

  final ClassicType type;
  final String title;
  final String description;
  final String contentsSubtitle;
  final List<String> contents;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final typeColor = type == ClassicType.tripitaka
        ? GudaColors.tripitaka
        : GudaColors.iching;

    return GudaCard(
      margin: const EdgeInsets.symmetric(horizontal: GudaSpacing.sm),
      padding: const EdgeInsets.all(GudaSpacing.xl),
      boxShadow: GudaShadows.bubble,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── 상단 아이콘 ──────────────────────────────
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: isDark
                  ? GudaColors.accent.withValues(alpha: 0.1)
                  : GudaColors.iching.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                type == ClassicType.iching
                    ? AppAssets.ichingImage
                    : AppAssets.tripitakaImage,
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: GudaSpacing.lg),

          // ── 타이틀 및 설명 ──────────────────────────
          Text(
            title,
            textAlign: TextAlign.center,
            style: GudaTypography.heading3(
              color: isDark
                  ? GudaColors.onSurfaceDark
                  : GudaColors.onSurfaceLight,
            ),
          ),
          const SizedBox(height: GudaSpacing.xs),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GudaTypography.body2(
              color: isDark
                  ? GudaColors.onSurfaceVariantDark
                  : GudaColors.onSurfaceVariantLight,
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: GudaSpacing.lg),
            child: GudaDivider(),
          ),

          // ── 수록 내용 ─────────────────────────────
          Text(
            contentsSubtitle,
            style: GudaTypography.captionBold(
              color: isDark
                  ? GudaColors.onSurfaceVariantDark
                  : GudaColors.onSurfaceVariantLight,
            ),
          ),
          const SizedBox(height: GudaSpacing.sm),
          GudaBulletList(
            items: contents,
            bulletColor: typeColor,
          ),
        ],
      ),
    );
  }
}
