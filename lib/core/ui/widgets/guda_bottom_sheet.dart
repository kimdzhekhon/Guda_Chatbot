import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

/// Guda 공통 바텀 시트 컨테이너
class GudaBottomSheet extends StatelessWidget {
  const GudaBottomSheet({
    super.key,
    required this.child,
    this.heightFactor = 0.7,
  });

  final Widget child;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * heightFactor,
      decoration: BoxDecoration(
        color: isDark ? GudaColors.surfaceDark : GudaColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(GudaRadius.xl),
        ),
        boxShadow: GudaShadows.bubble,
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: child,
      ),
    );
  }
}
