import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Guda 앱 타이포그래피 토큰
/// Google Fonts 사용 (Noto Serif KR, Inter) — 로컬 에셋 누락 방지
abstract final class GudaTypography {
  // ── 한국어 세리프 스타일 (경전 본문용) ──────────────
  /// 대제목 — 화면 타이틀
  static TextStyle heading1({Color? color}) => GoogleFonts.notoSerifKr(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.3,
    color: color,
  );

  /// 중제목 — 섹션 헤더
  static TextStyle heading2({Color? color}) => GoogleFonts.notoSerifKr(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.35,
    color: color,
  );

  /// 소제목 — 카드 타이틀, 대화 제목
  static TextStyle heading3({Color? color}) => GoogleFonts.notoSerifKr(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: color,
  );

  // ── 본문 스타일 ─────────────────────────────────
  /// 기본 본문 — AI 응답 텍스트
  static TextStyle body1({Color? color}) => GoogleFonts.notoSerifKr(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.75,
    color: color,
  );

  /// 보조 본문 — 메타 정보
  static TextStyle body2({Color? color}) => GoogleFonts.notoSerifKr(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: color,
  );

  // ── UI 인터랙션 스타일 ─────────────────────────────
  /// 버튼 텍스트
  static TextStyle button({Color? color}) => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: color,
  );

  /// 입력 필드 텍스트
  static TextStyle input({Color? color}) => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: color,
  );

  /// 캡션 — 날짜, 시간, 태그
  static TextStyle caption({Color? color}) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    color: color,
  );

  /// 앱 브랜드 타이틀 "Guda"
  static TextStyle brand({Color? color}) => GoogleFonts.notoSerifKr(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 6,
    color: color,
  );

  /// 한문 원문 인용 스타일 (경전 원문 렌더링용)
  static TextStyle classicQuote({Color? color}) => GoogleFonts.notoSerifKr(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 2.0,
    letterSpacing: 1.5,
    fontStyle: FontStyle.italic,
    color: color,
  );
}
