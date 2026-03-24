import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// Guda 공통 마크다운 위젯
/// 디자인 시스템의 타이포그래피와 색상을 일관되게 적용합니다.
class GudaMarkdown extends StatelessWidget {
  const GudaMarkdown({
    super.key,
    required this.data,
    required this.isDark,
    this.selectable = false,
  });

  final String data;
  final bool isDark;
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark
        ? GudaColors.onAssistantBubbleDark
        : GudaColors.onAssistantBubbleLight;

    return MarkdownBody(
      data: data.isEmpty ? '...' : data,
      selectable: selectable,
      styleSheet: MarkdownStyleSheet(
        p: GudaTypography.body1(color: textColor),
        h1: GudaTypography.heading1(color: textColor),
        h2: GudaTypography.heading2(color: textColor),
        h3: GudaTypography.heading3(color: textColor),
        listBullet: GudaTypography.body1(color: textColor),
        code: GudaTypography.classicQuote(color: GudaColors.accent),
        codeblockDecoration: BoxDecoration(
          color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.05),
          borderRadius: GudaRadius.smAll,
        ),
        horizontalRuleDecoration: BoxDecoration(
          border: Border.all(
            color: isDark ? GudaColors.dividerDark : GudaColors.dividerLight,
            width: 0.5,
          ),
        ),
      ),
    );
  }
}
