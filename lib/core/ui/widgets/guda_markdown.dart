import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

/// Guda 공통 마크다운 위젯
/// 디자인 시스템의 타이포그래피와 색상을 일관되게 적용합니다.
/// 동일 content + theme 조합의 MarkdownBody를 캐싱하여 재파싱 비용을 절감합니다.
class GudaMarkdown extends StatelessWidget {
  const GudaMarkdown({
    super.key,
    required this.data,
    this.selectable = false,
  });

  final String data;
  final bool selectable;

  // 라이트/다크 모드별 StyleSheet를 캐싱하여 매 빌드마다 재생성 방지
  static MarkdownStyleSheet? _cachedLightSheet;
  static MarkdownStyleSheet? _cachedDarkSheet;

  // MarkdownBody 위젯 캐시: (content + isDark) → 위젯 (LRU 방식, 최대 50개)
  static final Map<int, Widget> _bodyCache = {};
  static const int _maxCacheSize = 50;

  static MarkdownStyleSheet _getStyleSheet(bool isDark) {
    if (isDark) {
      return _cachedDarkSheet ??= _buildStyleSheet(isDark: true);
    }
    return _cachedLightSheet ??= _buildStyleSheet(isDark: false);
  }

  static MarkdownStyleSheet _buildStyleSheet({required bool isDark}) {
    final textColor = isDark
        ? GudaColors.onAssistantBubbleDark
        : GudaColors.onAssistantBubbleLight;

    return MarkdownStyleSheet(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final content = data.isEmpty ? '...' : data;

    // 스트리밍 중(짧은 content)은 캐시하지 않음 — 자주 변경되므로 캐시 오염 방지
    if (content.length < 20) {
      return MarkdownBody(
        data: content,
        selectable: selectable,
        styleSheet: _getStyleSheet(isDark),
      );
    }

    final cacheKey = Object.hash(content, isDark, selectable);
    final cached = _bodyCache[cacheKey];
    if (cached != null) return cached;

    final body = MarkdownBody(
      data: content,
      selectable: selectable,
      styleSheet: _getStyleSheet(isDark),
    );

    // LRU 캐시: 초과 시 가장 오래된 항목 제거
    if (_bodyCache.length >= _maxCacheSize) {
      _bodyCache.remove(_bodyCache.keys.first);
    }
    _bodyCache[cacheKey] = body;
    return body;
  }
}
