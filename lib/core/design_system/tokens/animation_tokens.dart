/// Guda 앱 애니메이션 Duration 토큰
abstract final class GudaDuration {
  static const Duration fastest = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration slower = Duration(milliseconds: 600);
  static const Duration slowest = Duration(milliseconds: 800);
}
