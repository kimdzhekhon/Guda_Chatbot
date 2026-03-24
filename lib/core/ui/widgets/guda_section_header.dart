import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// Guda 공통 섹션 헤더 — 그룹화된 리스트의 제목
class GudaSectionHeader extends StatelessWidget {
  const GudaSectionHeader({
    super.key,
    required this.title,
    this.padding = const EdgeInsets.fromLTRB(
      GudaSpacing.xl,
      GudaSpacing.xl,
      GudaSpacing.xl,
      GudaSpacing.sm,
    ),
  });

  final String title;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: padding,
      child: Text(
        title,
        style: GudaTypography.captionBold(
          color: colorScheme.primary,
        ),
      ),
    );
  }
}
