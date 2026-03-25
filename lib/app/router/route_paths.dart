/// 앱 내 모든 라우트 경로 상수
/// go_router의 path 인자로 직접 사용
abstract final class RoutePaths {
  /// 스플래시 화면 (SCR_SPLASH)
  static const String splash = '/';

  /// 인증 화면 (SCR_AUTH_GOOGLE)
  static const String auth = '/auth';

  /// 대화 목록 화면 (SCR_CHAT_LIST)
  static const String chatList = '/chat';

  /// 설정 화면 (SCR_SETTINGS)
  static const String settings = '/settings';

  /// 라이선스 화면 (SCR_LICENSE)
  static const String license = '/settings/license';

  /// 글자 크기 조절 화면 (SCR_FONT_SIZE)
  static const String fontSize = '/settings/font-size';
}
