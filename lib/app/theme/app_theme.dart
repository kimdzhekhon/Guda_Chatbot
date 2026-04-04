import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// Guda 앱 테마 팩토리 — 디자인 시스템 토큰 기반으로 ThemeData 조합
/// ThemeData를 캐싱하여 매 빌드마다 재생성 방지
abstract final class AppTheme {
  static ThemeData? _lightCache;
  static ThemeData? _darkCache;

  /// 라이트 모드 ThemeData (캐싱)
  static ThemeData light() => _lightCache ??= _build(
    colorScheme: GudaColorScheme.light(),
    brightness: Brightness.light,
    scaffoldBg: GudaColors.backgroundLight,
  );

  /// 다크 모드 ThemeData (캐싱)
  static ThemeData dark() => _darkCache ??= _build(
    colorScheme: GudaColorScheme.dark(),
    brightness: Brightness.dark,
    scaffoldBg: GudaColors.backgroundDark,
  );

  static ThemeData _build({
    required ColorScheme colorScheme,
    required Brightness brightness,
    required Color scaffoldBg,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBg,

      // ── 앱바 ─────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GudaTypography.heading3(color: colorScheme.onSurface),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),

      // ── 카드 ─────────────────────────────────────
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: GudaRadius.mdAll),
        margin: const EdgeInsets.symmetric(
          horizontal: GudaSpacing.md,
          vertical: GudaSpacing.xs,
        ),
      ),

      // ── 입력 필드 ─────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: const OutlineInputBorder(
          borderRadius: GudaRadius.mdAll,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: GudaRadius.mdAll,
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: GudaSpacing.md,
          vertical: GudaSpacing.md12,
        ),
      ),

      // ── 구분선 ────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 0.5,
        space: 0,
      ),

      // ── 리스트 타일 ───────────────────────────────
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: GudaSpacing.md,
          vertical: GudaSpacing.xs,
        ),
        shape: RoundedRectangleBorder(borderRadius: GudaRadius.mdAll),
      ),

      // ── 아이콘 ────────────────────────────────────
      iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant, size: 24),
    );
  }
}
