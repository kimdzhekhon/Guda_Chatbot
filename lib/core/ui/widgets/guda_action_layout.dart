import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// Guda 공통 액션/질문 레이아웃
/// 대화 시작 전 단계별 뷰(InitialQuestion)의 일관된 타이틀, 간격, 정렬을 제공합니다.
class GudaActionLayout extends StatelessWidget {
  const GudaActionLayout({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.isDark = false,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: GudaSpacing.md),
        // ── 타이틀 ──────────────────────────────
        Text(
          title,
          style: GudaTypography.heading3(
            color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
          ).copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: GudaSpacing.lg),
          // ── 서브타이틀 ──────────────────────────
          Text(
            subtitle!,
            style: GudaTypography.body2(
              color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: GudaSpacing.lg),
        // ── 본문 (그리드, 입력창 등) ──────────────────
        child,
        const SizedBox(height: GudaSpacing.lg),
      ],
    );
  }
}
