import 'package:flutter/material.dart';

/// Guda 앱 타이포그래피 토큰
/// 로컬 폰트 사용 (Noto Serif KR, Inter)
abstract final class GudaTypography {
  // ── 한국어 세리프 스타일 (경전 본문용) ──────────────
  /// 대제목 — 화면 타이틀
  static TextStyle heading1({Color? color}) => TextStyle(
    fontFamily: 'NotoSerifKR',
    fontSize: 31,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.3,
    color: color,
  );

  /// 홈 화면 앱바 타이틀 (특수 스타일)
  static TextStyle homeTitle({Color? color}) => TextStyle(
    fontFamily: 'NotoSerifKR',
    fontSize: 25,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.0,
    height: 1.35,
    color: color,
  );

  /// 중제목 — 섹션 헤더
  static TextStyle heading2({Color? color}) => TextStyle(
    fontFamily: 'NotoSerifKR',
    fontSize: 25,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.35,
    color: color,
  );

  /// 소제목 — 카드 타이틀, 대화 제목
  static TextStyle heading3({Color? color}) => TextStyle(
    fontFamily: 'NotoSerifKR',
    fontSize: 21,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: color,
  );

  // ── 본문 스타일 ─────────────────────────────────
  /// 기본 본문 — AI 응답 텍스트
  static TextStyle body1({Color? color}) => TextStyle(
    fontFamily: 'NotoSerifKR',
    fontSize: 19,
    fontWeight: FontWeight.w400,
    height: 1.75,
    color: color,
  );

  /// 기본 본문 강조
  static TextStyle body1Bold({Color? color}) => TextStyle(
    fontFamily: 'NotoSerifKR',
    fontSize: 19,
    fontWeight: FontWeight.w700,
    height: 1.75,
    color: color,
  );

  /// 보조 본문 — 메타 정보
  static TextStyle body2({Color? color}) => TextStyle(
    fontFamily: 'NotoSerifKR',
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: color,
  );

  /// 보조 본문 강조
  static TextStyle body2Bold({Color? color}) => TextStyle(
    fontFamily: 'NotoSerifKR',
    fontSize: 17,
    fontWeight: FontWeight.w700,
    height: 1.6,
    color: color,
  );

  // ── UI 인터랙션 스타일 ─────────────────────────────
  /// 버튼 텍스트
  static TextStyle button({Color? color}) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: color,
  );

  /// 입력 필드 텍스트
  static TextStyle input({Color? color}) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: color,
  );

  /// 캡션 1 — 날짜, 시간, 태그
  static TextStyle caption({Color? color}) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.3,
    color: color,
  );

  /// 캡션 1 강조 — 섹션 헤더 등
  static TextStyle captionBold({Color? color}) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    height: 1.3,
    color: color,
  );

  /// 캡션 1 중간 강조
  static TextStyle captionSemiBold({Color? color}) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: color,
  );

  /// 캡션 2 — 버전 정보, 부가 설명
  static TextStyle caption2({Color? color}) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    color: color,
  );

  /// 최소 캡션 — 매우 작은 텍스트 (한자 등)
  static TextStyle tiny({Color? color}) => TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: color,
  );

  /// 소형 라벨 — 작은 브랜드 타이틀, 소제목
  static TextStyle labelSmall({Color? color}) => TextStyle(
    fontFamily: 'NotoSerifKR',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: color,
  );

  /// 앱 브랜드 타이틀 "Guda"
  static TextStyle brand({Color? color}) => TextStyle(
    fontFamily: 'NotoSerifKR',
    fontSize: 35,
    fontWeight: FontWeight.w700,
    letterSpacing: 6,
    color: color,
  );

  /// 한문 원문 인용 스타일 (경전 원문 렌더링용)
  static TextStyle classicQuote({Color? color}) => TextStyle(
    fontFamily: 'NotoSerifKR',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 2.0,
    letterSpacing: 1.5,
    fontStyle: FontStyle.italic,
    color: color,
  );
}
