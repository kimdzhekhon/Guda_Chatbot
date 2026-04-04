import 'package:flutter/material.dart';

/// Guda 앱 타이포그래피 토큰
/// 로컬 폰트 사용 (Noto Serif KR, Inter)
///
/// 최적화: 색상 없는 base TextStyle을 static final로 캐싱하고,
/// color가 필요할 때만 copyWith()로 복제합니다.
abstract final class GudaTypography {
  // ── 캐시된 Base TextStyle ─────────────────────────
  static const _heading1 = TextStyle(
    fontFamily: 'NotoSerifKR',
    fontSize: 31,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.3,
  );

  static const _homeTitle = TextStyle(
    fontFamily: 'NotoSerifKR',
    fontSize: 25,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.0,
    height: 1.35,
  );

  static const _heading2 = TextStyle(
    fontFamily: 'NotoSerifKR',
    fontSize: 25,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.35,
  );

  static const _heading3 = TextStyle(
    fontFamily: 'NotoSerifKR',
    fontSize: 21,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const _body1 = TextStyle(
    fontFamily: 'NotoSerifKR',
    fontSize: 19,
    fontWeight: FontWeight.w400,
    height: 1.75,
  );

  static const _body1Bold = TextStyle(
    fontFamily: 'NotoSerifKR',
    fontSize: 19,
    fontWeight: FontWeight.w700,
    height: 1.75,
  );

  static const _body2 = TextStyle(
    fontFamily: 'NotoSerifKR',
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const _body2Bold = TextStyle(
    fontFamily: 'NotoSerifKR',
    fontSize: 17,
    fontWeight: FontWeight.w700,
    height: 1.6,
  );

  static const _button = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  static const _input = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const _caption = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.3,
  );

  static const _captionBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    height: 1.3,
  );

  static const _captionSemiBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static const _caption2 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
  );

  static const _tiny = TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    fontWeight: FontWeight.w400,
  );

  static const _labelSmall = TextStyle(
    fontFamily: 'NotoSerifKR',
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const _brand = TextStyle(
    fontFamily: 'NotoSerifKR',
    fontSize: 35,
    fontWeight: FontWeight.w700,
    letterSpacing: 6,
  );

  static const _classicQuote = TextStyle(
    fontFamily: 'NotoSerifKR',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 2.0,
    letterSpacing: 1.5,
    fontStyle: FontStyle.italic,
  );

  // ── Public API (color 적용 시에만 copyWith) ─────────
  static TextStyle heading1({Color? color}) =>
      color == null ? _heading1 : _heading1.copyWith(color: color);

  static TextStyle homeTitle({Color? color}) =>
      color == null ? _homeTitle : _homeTitle.copyWith(color: color);

  static TextStyle heading2({Color? color}) =>
      color == null ? _heading2 : _heading2.copyWith(color: color);

  static TextStyle heading3({Color? color}) =>
      color == null ? _heading3 : _heading3.copyWith(color: color);

  static TextStyle body1({Color? color}) =>
      color == null ? _body1 : _body1.copyWith(color: color);

  static TextStyle body1Bold({Color? color}) =>
      color == null ? _body1Bold : _body1Bold.copyWith(color: color);

  static TextStyle body2({Color? color}) =>
      color == null ? _body2 : _body2.copyWith(color: color);

  static TextStyle body2Bold({Color? color}) =>
      color == null ? _body2Bold : _body2Bold.copyWith(color: color);

  static TextStyle button({Color? color}) =>
      color == null ? _button : _button.copyWith(color: color);

  static TextStyle input({Color? color}) =>
      color == null ? _input : _input.copyWith(color: color);

  static TextStyle caption({Color? color}) =>
      color == null ? _caption : _caption.copyWith(color: color);

  static TextStyle captionBold({Color? color}) =>
      color == null ? _captionBold : _captionBold.copyWith(color: color);

  static TextStyle captionSemiBold({Color? color}) =>
      color == null ? _captionSemiBold : _captionSemiBold.copyWith(color: color);

  static TextStyle caption2({Color? color}) =>
      color == null ? _caption2 : _caption2.copyWith(color: color);

  static TextStyle tiny({Color? color}) =>
      color == null ? _tiny : _tiny.copyWith(color: color);

  static TextStyle labelSmall({Color? color}) =>
      color == null ? _labelSmall : _labelSmall.copyWith(color: color);

  static TextStyle brand({Color? color}) =>
      color == null ? _brand : _brand.copyWith(color: color);

  static TextStyle classicQuote({Color? color}) =>
      color == null ? _classicQuote : _classicQuote.copyWith(color: color);
}
