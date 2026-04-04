import 'package:flutter/material.dart';

/// Guda 공통 스트리밍 도트 애니메이션
class GudaStreamingDots extends StatefulWidget {
  const GudaStreamingDots({super.key, this.color});

  final Color? color;

  @override
  State<GudaStreamingDots> createState() => _GudaStreamingDotsState();
}

class _GudaStreamingDotsState extends State<GudaStreamingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dotColor = widget.color ?? colorScheme.primary;

    return RepaintBoundary(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final delay = index * 0.2;
              double value = (_controller.value - delay) % 1.0;
              if (value < 0) value += 1.0;

              double scale = 0.5;
              if (value < 0.4) {
                scale = 0.5 + (0.5 * (value / 0.4));
              } else if (value < 0.8) {
                scale = 1.0 - (0.5 * ((value - 0.4) / 0.4));
              }

              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                ),
                transform: Matrix4.diagonal3Values(scale, scale, 1.0),
                transformAlignment: Alignment.center,
              );
            },
          );
        }),
      ),
    );
  }
}
