import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

/// Guda 공통 페이지 인디케이터
/// 가로형 캐러셀이나 페이지 뷰의 현재 위치를 시각적으로 보여줍니다.
class GudaPageIndicator extends StatelessWidget {
  const GudaPageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.activeWidth = 24.0,
    this.inactiveWidth = 8.0,
    this.height = 8.0,
    this.activeColor,
    this.inactiveColor,
    this.spacing = GudaSpacing.xs,
  });

  final int count;
  final int currentIndex;
  final double activeWidth;
  final double inactiveWidth;
  final double height;
  final Color? activeColor;
  final Color? inactiveColor;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final effectiveActiveColor = activeColor ?? GudaColors.accent;
    final effectiveInactiveColor = inactiveColor ?? 
        (isDark ? GudaColors.dividerDark : GudaColors.dividerLight);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = currentIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: isActive ? activeWidth : inactiveWidth,
          height: height,
          decoration: BoxDecoration(
            color: isActive ? effectiveActiveColor : effectiveInactiveColor,
            borderRadius: BorderRadius.circular(height / 2),
          ),
        );
      }),
    );
  }
}
