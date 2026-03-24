import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_hexagram.dart';

export 'package:guda_chatbot/core/ui/widgets/guda_hexagram.dart' show HexagramPainter;

/// 괘 이미지를 보여주는 위젯
/// (기존 위젯 호환성을 위해 유지하며 GudaHexagram을 래핑)
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
    return GudaHexagram(
      lines: lines,
      size: size,
      color: color,
    );
  }
}
