import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// BuildContext 확장을 통한 디자인 시스템 및 테마 접근 최적화
extension GudaContextExtensions on BuildContext {
  /// 테마의 다크 모드 여부
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// 테마의 ColorScheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// 테마의 TextTheme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Guda 디자인 시스템 커스텀 색상 토큰
  /// (GudaColors와 테마 상태를 조합하여 반환)
  Color get backgroundColor => isDark ? GudaColors.backgroundDark : GudaColors.backgroundLight;
  Color get surfaceColor => isDark ? GudaColors.surfaceDark : GudaColors.surfaceLight;
  Color get cardColor => isDark ? GudaColors.surfaceDark : GudaColors.surfaceLight;
  Color get dividerColor => isDark ? GudaColors.dividerDark : GudaColors.dividerLight;
  Color get onSurfaceColor => isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight;
  Color get onSurfaceVariantColor => isDark ? GudaColors.onSurfaceVariantDark : GudaColors.onSurfaceVariantLight;
  Color get outlineColor => colorScheme.outline;
  Color get primaryColor => colorScheme.primary;
  Color get secondaryColor => colorScheme.secondary;
  Color get tertiaryColor => colorScheme.tertiary;
  Color get errorColor => colorScheme.error;
  Color get accentColor => GudaColors.accent;

  /// Chat Bubble Tokens
  Color get userBubbleColor => isDark ? GudaColors.userBubbleDark : GudaColors.userBubbleLight;
  Color get assistantBubbleColor => isDark ? GudaColors.assistantBubbleDark : GudaColors.assistantBubbleLight;
  Color get onUserBubbleColor => GudaColors.onUserBubble;
  Color get onAssistantBubbleColor => isDark ? GudaColors.onAssistantBubbleDark : GudaColors.onAssistantBubbleLight;

  /// Typography Shortcuts
  TextStyle get h1 => GudaTypography.heading1(color: onSurfaceColor);
  TextStyle get h2 => GudaTypography.heading2(color: onSurfaceColor);
  TextStyle get h3 => GudaTypography.heading3(color: onSurfaceColor);
  TextStyle get body1 => GudaTypography.body1(color: onSurfaceColor);
  TextStyle get body2 => GudaTypography.body2(color: onSurfaceColor);
  TextStyle get caption => GudaTypography.caption(color: onSurfaceVariantColor);
}
