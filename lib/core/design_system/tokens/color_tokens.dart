import 'package:flutter/material.dart';

/// Guda 앱 색상 토큰 — Zen 테마 (딥 인디고 + 골드 + 웜 아이보리)
/// 모든 컬러 리터럴 사용 금지, 반드시 이 클래스를 통해 참조
abstract final class GudaColors {
  // ── 브랜드 색상 ──────────────────────────────
  /// 주 색상: 딥 인디고 (더 깊고 고급스러운 톤)
  static const Color primary = Color(0xFF141033);

  /// 주 색상 밝은 변형
  static const Color primaryLight = Color(0xFF26204A);

  /// 강조 색상: 한국 전통 금색 (채도와 명도 최적화)
  static const Color accent = Color(0xFFA37521);

  /// 강조 색상 밝은 변형
  static const Color accentLight = Color(0xFFC4953B);

  // ── 배경/표면 ─────────────────────────────────
  /// 라이트 배경 (웜 아이보리 유지)
  static const Color backgroundLight = Color(0xFFFBF9F4);

  /// 다크 배경
  static const Color backgroundDark = Color(0xFF0D0B1A);

  /// 라이트 표면 (카드)
  static const Color surfaceLight = Color(0xFFFFFFFF);

  /// 다크 표면 (카드)
  static const Color surfaceDark = Color(0xFF18152B);

  /// 라이트 보조 표면 (연한 모래색)
  static const Color surfaceVariantLight = Color(0xFFF4F1E8);

  /// 다크 보조 표면
  static const Color surfaceVariantDark = Color(0xFF211D3D);

  // ── 텍스트 ───────────────────────────────────
  /// 라이트 기본 텍스트
  static const Color onSurfaceLight = Color(0xFF141033);

  /// 다크 기본 텍스트
  static const Color onSurfaceDark = Color(0xFFF2F0F7);

  /// 라이트 보조 텍스트
  static const Color onSurfaceVariantLight = Color(0xFF554D6D);

  /// 다크 보조 텍스트
  static const Color onSurfaceVariantDark = Color(0xFFA19ABF);

  // ── 채팅 버블 ─────────────────────────────────
  /// 사용자 메시지 버블 배경
  static const Color userBubbleLight = Color(0xFF141033);

  /// 사용자 메시지 버블 배경 (다크)
  static const Color userBubbleDark = Color(0xFF26204A);

  /// 사용자 메시지 버블 텍스트
  static const Color onUserBubble = Color(0xFFFFFFFF);

  /// AI 메시지 버블 배경 (라이트)
  static const Color assistantBubbleLight = Color(0xFFEBE4D1);

  /// AI 메시지 버블 배경 (다크)
  static const Color assistantBubbleDark = Color(0xFF211D3D);

  /// AI 메시지 버블 텍스트 (라이트)
  static const Color onAssistantBubbleLight = Color(0xFF141033);

  /// AI 메시지 버블 텍스트 (다크)
  static const Color onAssistantBubbleDark = Color(0xFFF2F0F7);

  // ── 상태 색상 ─────────────────────────────────
  /// 오류
  static const Color error = Color(0xFFD32F2F);

  /// 성공
  static const Color success = Color(0xFF388E3C);

  /// 경고
  static const Color warning = Color(0xFFFBC02D);

  // ── 구분선 ───────────────────────────────────
  /// 라이트 구분선
  static const Color dividerLight = Color(0xFFE5E0D0);

  /// 다크 구분선
  static const Color dividerDark = Color(0xFF2A2645);

  // ── 고전 유형별 色 ─────────────────────────────
  /// 팔만대장경 — 연꽃 분홍 (더 세련된 톤)
  static const Color tripitaka = Color(0xFF9E546F);

  /// 주역 — 청옥색
  static const Color iching = Color(0xFF28627E);

  /// 구사론 — 사프란 황색
  static const Color abhidharma = Color(0xFFA36D1D);

  // ── 소셜 브랜드 ──────────────────────────────
  /// Google 브랜드 색상 (텍스트/아이콘용)
  static const Color google = Color(0xFF141033); // Guda 테마에 맞춘 다크 인디고
  
  /// Google 배경색 (라이트 그레이 - 사용자 요청 사양)
  static const Color googleBackground = Color(0xFFF2F2F2);

  /// Apple 브랜드 색상 (배경용)
  static const Color apple = Color(0xFF000000);

  /// Apple 텍스트색 (화이트)
  static const Color onApple = Color(0xFFFFFFFF);
}
