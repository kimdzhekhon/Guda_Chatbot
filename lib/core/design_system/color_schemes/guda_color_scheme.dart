import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/tokens/color_tokens.dart';

/// Guda 앱 ColorScheme 팩토리 — 라이트/다크 모드
abstract final class GudaColorScheme {
  /// 라이트 모드 ColorScheme
  static ColorScheme light() => ColorScheme(
    brightness: Brightness.light,
    primary: GudaColors.primary,
    onPrimary: Colors.white,
    primaryContainer: GudaColors.primaryLight,
    onPrimaryContainer: Colors.white,
    secondary: GudaColors.accent,
    onSecondary: Colors.white,
    secondaryContainer: GudaColors.accentLight.withValues(alpha: 0.2),
    onSecondaryContainer: GudaColors.primary,
    surface: GudaColors.surfaceLight,
    onSurface: GudaColors.onSurfaceLight,
    surfaceContainerHighest: GudaColors.surfaceVariantLight,
    onSurfaceVariant: GudaColors.onSurfaceVariantLight,
    error: GudaColors.error,
    onError: Colors.white,
    outline: GudaColors.dividerLight,
    outlineVariant: GudaColors.dividerLight.withValues(alpha: 0.5),
    scrim: GudaColors.primary.withValues(alpha: 0.5),
    shadow: GudaColors.primary.withValues(alpha: 0.15),
    inversePrimary: GudaColors.accentLight,
    inverseSurface: GudaColors.surfaceDark,
    onInverseSurface: GudaColors.onSurfaceDark,
  );

  /// 다크 모드 ColorScheme
  static ColorScheme dark() => ColorScheme(
    brightness: Brightness.dark,
    primary: GudaColors.accentLight,
    onPrimary: GudaColors.primary,
    primaryContainer: GudaColors.primaryLight,
    onPrimaryContainer: GudaColors.onSurfaceDark,
    secondary: GudaColors.accent,
    onSecondary: Colors.white,
    secondaryContainer: GudaColors.accent.withValues(alpha: 0.2),
    onSecondaryContainer: GudaColors.accentLight,
    surface: GudaColors.surfaceDark,
    onSurface: GudaColors.onSurfaceDark,
    surfaceContainerHighest: GudaColors.surfaceVariantDark,
    onSurfaceVariant: GudaColors.onSurfaceVariantDark,
    error: const Color(0xFFCF6679),
    onError: Colors.white,
    outline: GudaColors.dividerDark,
    outlineVariant: GudaColors.dividerDark.withValues(alpha: 0.5),
    scrim: Colors.black.withValues(alpha: 0.6),
    shadow: Colors.black.withValues(alpha: 0.4),
    inversePrimary: GudaColors.primary,
    inverseSurface: GudaColors.surfaceLight,
    onInverseSurface: GudaColors.onSurfaceLight,
  );
}
