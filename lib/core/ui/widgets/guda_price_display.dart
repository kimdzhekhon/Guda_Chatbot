import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// 가격 표시 전용 위젯
/// 큰 숫자와 '원' 단위를 정렬하여 보여줍니다.
class GudaPriceDisplay extends StatelessWidget {
  const GudaPriceDisplay({
    super.key,
    required this.price,
    this.currency = '원',
    this.fontSize = 36,
    this.alignment = MainAxisAlignment.center,
  });

  final num price;
  final String currency;
  final double fontSize;
  final MainAxisAlignment alignment;

  static String format(num number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: alignment,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          format(price),
          style: GudaTypography.heading1(
            color: GudaColors.accent,
          ).copyWith(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          currency,
          style: GudaTypography.body1(
            color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
          ),
        ),
      ],
    );
  }
}
