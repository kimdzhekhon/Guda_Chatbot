import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// Guda 공통 구분선 위젯
/// 디자인 시스템의 색상과 일관된 투명도를 적용합니다.
class GudaDivider extends StatelessWidget {
  const GudaDivider({
    super.key,
    this.height = 1.0,
    this.thickness = 0.5,
    this.indent,
    this.endIndent,
    this.alpha = 0.5,
    this.color,
  });

  final double height;
  final double thickness;
  final double? indent;
  final double? endIndent;
  final double alpha;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = color ?? theme.dividerTheme.color ?? 
        (theme.brightness == Brightness.dark ? GudaColors.dividerDark : GudaColors.dividerLight);
    final finalColor = defaultColor;

    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: finalColor.withValues(alpha: alpha),
    );
  }
}
