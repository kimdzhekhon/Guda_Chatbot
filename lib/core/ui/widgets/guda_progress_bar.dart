import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

/// Guda 공통 프로그레스 바 위젯
class GudaProgressBar extends StatelessWidget {
  const GudaProgressBar({
    super.key,
    required this.value,
    this.backgroundColor,
    this.color,
    this.minHeight = 8.0,
    this.borderRadius,
  });

  /// 0.0 ~ 1.0 사이의 값
  final double value;

  /// 배경색 (기본값: context.colorScheme.outlineVariant)
  final Color? backgroundColor;

  /// 진행바 색상 (기본값: GudaColors.accent)
  final Color? color;

  /// 최소 높이 (기본값: 8.0)
  final double minHeight;

  /// 테두리 곡률 (기본값: GudaRadius.smAll)
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? GudaRadius.smAll,
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: backgroundColor ?? context.colorScheme.outlineVariant,
        color: color ?? GudaColors.accent,
        minHeight: minHeight,
      ),
    );
  }
}
