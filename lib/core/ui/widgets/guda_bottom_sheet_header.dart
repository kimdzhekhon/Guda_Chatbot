import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// Guda 바텀 시트/모달 공통 헤더
/// 드래그 핸들, 타이틀, 닫기 버튼을 포함하는 일관된 디자인을 제공합니다.
class GudaBottomSheetHeader extends StatelessWidget {
  const GudaBottomSheetHeader({
    super.key,
    required this.title,
    this.onClose,
    this.showDragHandle = true,
  });

  final String title;
  final VoidCallback? onClose;
  final bool showDragHandle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDragHandle) ...[
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? GudaColors.dividerDark : GudaColors.dividerLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GudaTypography.heading2(
                  color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
                ),
              ),
              if (onClose != null)
                IconButton(
                  onPressed: onClose,
                  icon: Icon(
                    Icons.close_rounded,
                    color: isDark
                        ? GudaColors.onSurfaceVariantDark
                        : GudaColors.onSurfaceVariantLight,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
