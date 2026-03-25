import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// 보관함 및 기록용 카드 위젯
/// 왼쪽에 브랜드 컬러 포인트 바가 있는 것이 특징입니다.
class GudaBookmarkTile extends StatelessWidget {
  const GudaBookmarkTile({
    super.key,
    required this.title,
    required this.content,
    required this.date,
    this.onTap,
    this.onDelete,
  });

  final String title;
  final String content;
  final String date;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? GudaColors.surfaceDark : Colors.white,
        borderRadius: GudaRadius.mdAll,
        boxShadow: GudaShadows.card,
      ),
      child: ClipRRect(
        borderRadius: GudaRadius.mdAll,
        child: IntrinsicHeight(
          child: InkWell(
            onTap: onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── 사이드 인디케이터 (포인트) ──────────────────
                Container(
                  width: 6,
                  color: GudaColors.primary,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(GudaSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: GudaTypography.body1Bold(
                                  color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (onDelete != null)
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: GudaColors.error,
                                  size: 20,
                                ),
                                onPressed: onDelete,
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                          ],
                        ),
                        const SizedBox(height: GudaSpacing.xs),
                        Text(
                          content,
                          style: GudaTypography.body2(
                            color: isDark ? GudaColors.onSurfaceVariantDark : GudaColors.onSurfaceVariantLight,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: GudaSpacing.sm),
                        Text(
                          date,
                          style: GudaTypography.caption2(
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
