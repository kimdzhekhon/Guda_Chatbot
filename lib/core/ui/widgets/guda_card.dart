import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// Guda 공통 카드 위젯
/// 디자인 시스템의 색상, 곡률, 그림자를 일관되게 적용합니다.
class GudaCard extends StatelessWidget {
  const GudaCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.constraints,
    this.backgroundColor,
    this.borderRadius,
    this.showBorder = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(GudaSpacing.lg),
      constraints: constraints,
      decoration: BoxDecoration(
        color: backgroundColor ?? (isDark ? GudaColors.surfaceDark : GudaColors.surfaceLight),
        borderRadius: borderRadius ?? GudaRadius.lgAll,
        boxShadow: GudaShadows.card,
        border: showBorder 
            ? Border.all(
                color: (isDark ? GudaColors.dividerDark : GudaColors.dividerLight)
                    .withValues(alpha: 0.5),
                width: 0.5,
              )
            : null,
      ),
      child: child,
    );
  }
}
