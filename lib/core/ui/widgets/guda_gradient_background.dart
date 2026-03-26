import 'package:flutter/material.dart';

/// Guda 공통 그라데이션 배경 컨테이너
/// 앱의 시그니처 색상을 활용한 그라데이션 배경을 제공합니다.
class GudaGradientBackground extends StatelessWidget {
  const GudaGradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.stops,
  });

  final Widget child;
  final List<Color>? colors;
  final List<double>? stops;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors ??
              [
                colorScheme.primary,
                colorScheme.primary.withValues(alpha: 0.7),
                colorScheme.surface,
              ],
          stops: stops ?? const [0.0, 0.4, 1.0],
        ),
      ),
      child: child,
    );
  }
}
