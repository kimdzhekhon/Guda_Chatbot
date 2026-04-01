import 'package:flutter/material.dart';

/// Guda 앱 곡률(Radius) 토큰
abstract final class GudaRadius {
  /// 4dp — 최소 곡률
  static const double xs = 4.0;

  /// 8dp — 소형 (입력 필드, 칩)
  static const double sm = 8.0;

  /// 16dp — 기본 (카드, 버튼)
  static const double md = 16.0;

  /// 20dp — 채팅 버블
  static const double bubble = 20.0;

  /// 24dp — 대형 (바텀시트, 모달)
  static const double lg = 24.0;

  /// 32dp — 초대형 (라운드 컨테이너)
  static const double xl = 32.0;

  /// 999dp — 완전 원형 (아바타, 알약형 버튼)
  static const double full = 999.0;

  // ── BorderRadius 헬퍼 ────────────────────────────
  static const BorderRadius xsAll = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius fullAll = BorderRadius.all(Radius.circular(full));

  /// 채팅 버블 — 사용자 (우측 하단만 뾰족)
  static const BorderRadius userBubble = BorderRadius.only(
    topLeft: Radius.circular(bubble),
    topRight: Radius.circular(bubble),
    bottomLeft: Radius.circular(bubble),
    bottomRight: Radius.circular(xs),
  );

  /// 채팅 버블 — AI (좌측 상단만 뾰족)
  static const BorderRadius assistantBubble = BorderRadius.only(
    topLeft: Radius.circular(xs),
    topRight: Radius.circular(bubble),
    bottomLeft: Radius.circular(bubble),
    bottomRight: Radius.circular(bubble),
  );
}
