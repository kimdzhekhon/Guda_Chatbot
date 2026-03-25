import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_section_header.dart';

/// Guda 공통 섹션 레이아웃 위젯
/// 헤더와 콘텐츠를 그룹화하여 일관된 간격을 제공합니다.
class GudaSection extends StatelessWidget {
  const GudaSection({
    super.key,
    required this.title,
    required this.child,
    this.headerPadding,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: GudaSpacing.md),
    this.spacing = GudaSpacing.xs,
  });

  final String title;
  final Widget child;
  final EdgeInsetsGeometry? headerPadding;
  final EdgeInsetsGeometry contentPadding;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GudaSectionHeader(
          title: title,
          padding: headerPadding ?? const EdgeInsets.fromLTRB(
            GudaSpacing.xl,
            GudaSpacing.xl,
            GudaSpacing.xl,
            GudaSpacing.sm,
          ),
        ),
        SizedBox(height: spacing),
        Padding(
          padding: contentPadding,
          child: child,
        ),
      ],
    );
  }
}
