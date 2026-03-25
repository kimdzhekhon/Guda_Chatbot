import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_bullet_item.dart';

/// Guda 공통 불렛 리스트 — 문자열 리스트를 시각화
class GudaBulletList extends StatelessWidget {
  const GudaBulletList({
    super.key,
    required this.items,
    this.bulletColor,
  });

  final List<String> items;
  final Color? bulletColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => GudaBulletItem(
              content: item,
              isDark: isDark,
              bulletColor: bulletColor,
            ),
          )
          .toList(),
    );
  }
}
