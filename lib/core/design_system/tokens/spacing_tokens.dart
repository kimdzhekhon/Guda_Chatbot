/// Guda 앱 간격(Spacing) 토큰
/// 4pt 그리드 시스템 기반
abstract final class GudaSpacing {
  /// 4dp — 매우 작은 간격 (아이콘 내부 패딩 등)
  static const double xs = 4.0;

  /// 8dp — 작은 간격 (인라인 요소 간격)
  static const double sm = 8.0;

  /// 12dp — 중소 간격
  static const double md12 = 12.0;

  /// 16dp — 기본 간격 (패딩, 마진)
  static const double md = 16.0;

  /// 20dp — 중간 간격
  static const double md20 = 20.0;

  /// 24dp — 큰 간격 (섹션 구분)
  static const double lg = 24.0;

  /// 32dp — 매우 큰 간격
  static const double xl = 32.0;

  /// 48dp — 최대 간격 (화면 영역 구분)
  static const double xxl = 48.0;

  /// 64dp — 초대형 간격 (스플래시 로고 등)
  static const double xxxl = 64.0;
}
