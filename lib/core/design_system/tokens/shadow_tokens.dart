import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/tokens/color_tokens.dart';

/// Guda 앱 그림자(Shadow) 토큰
/// static final -> static final (withValues는 런타임이므로 const 불가, 인스턴스 재생성 방지)
abstract final class GudaShadows {
  /// 카드 그림자 — 기본 엘리베이션
  static final List<BoxShadow> card = List.unmodifiable([
    BoxShadow(
      color: GudaColors.primary.withValues(alpha: 0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: GudaColors.primary.withValues(alpha: 0.04),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ]);

  /// 채팅 버블 그림자
  static final List<BoxShadow> bubble = List.unmodifiable([
    BoxShadow(
      color: GudaColors.primary.withValues(alpha: 0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ]);

  /// 입력창 그림자
  static final List<BoxShadow> inputBar = List.unmodifiable([
    BoxShadow(
      color: GudaColors.primary.withValues(alpha: 0.12),
      blurRadius: 20,
      offset: const Offset(0, -4),
    ),
  ]);

  /// 모달/바텀시트 그림자
  static final List<BoxShadow> modal = List.unmodifiable([
    BoxShadow(
      color: GudaColors.primary.withValues(alpha: 0.2),
      blurRadius: 40,
      offset: const Offset(0, -8),
    ),
  ]);

  /// 사이드바 그림자 (데스크톱)
  static final List<BoxShadow> sidebar = List.unmodifiable([
    BoxShadow(
      color: GudaColors.primary.withValues(alpha: 0.15),
      blurRadius: 24,
      offset: const Offset(4, 0),
    ),
  ]);
}
