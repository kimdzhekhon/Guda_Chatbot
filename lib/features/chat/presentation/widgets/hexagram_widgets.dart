import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// 주역의 괘(Hexagram)를 그리는 Painter
class HexagramPainter extends CustomPainter {
  final List<int> lines;
  final Color color;
  final double strokeWidth;
  final double gapWidth;

  HexagramPainter({
    required this.lines,
    required this.color,
    this.strokeWidth = 3.0,
    this.gapWidth = 6.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double lineHeight = size.height / 6;
    final double itemSpacing = lineHeight * 0.4;
    final double actualLineHeight = lineHeight - itemSpacing;

    for (int i = 0; i < 6; i++) {
      // 주역은 밑에서부터 읽으므로 인덱스 역순 (0번째가 가장 아래)
      final int lineValue = lines[i];
      // 그리는 순서는 위에서 아래이므로 y축 계산 (5-i)
      final double y = (5 - i) * lineHeight + (itemSpacing / 2) + (actualLineHeight / 2);

      if (lineValue == 1) {
        // 양(陽): 이어지는 선
        canvas.drawLine(
          Offset(0, y),
          Offset(size.width, y),
          paint,
        );
      } else {
        // 음(陰): 끊어진 선
        final double halfWidth = size.width / 2;
        final double centerGap = gapWidth;
        
        // 왼쪽 선
        canvas.drawLine(
          Offset(0, y),
          Offset(halfWidth - (centerGap / 2), y),
          paint,
        );
        
        // 오른쪽 선
        canvas.drawLine(
          Offset(halfWidth + (centerGap / 2), y),
          Offset(size.width, y),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant HexagramPainter oldDelegate) {
    return oldDelegate.lines != lines || oldDelegate.color != color;
  }
}

/// 괘 이미지를 보여주는 위젯
class HexagramWidget extends StatelessWidget {
  final List<int> lines;
  final double size;
  final Color? color;

  const HexagramWidget({
    super.key,
    required this.lines,
    this.size = 40.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strokeColor = color ?? (isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight);

    return CustomPaint(
      size: Size(size, size * 0.8), // 6줄이므로 약간 가로가 긴 비율이 안정적
      painter: HexagramPainter(
        lines: lines,
        color: strokeColor,
        strokeWidth: size * 0.08,
        gapWidth: size * 0.15,
      ),
    );
  }
}
