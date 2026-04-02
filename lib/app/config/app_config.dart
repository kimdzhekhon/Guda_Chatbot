/// Guda 앱 환경 설정
/// 빌드 시 --dart-define으로 주입: flutter run --dart-define-from-file=.env
/// 로컬 개발 시 .env 파일에 기본값 설정 (.gitignore에 추가 필수)
abstract final class AppConfig {
  // ── Supabase 설정 ─────────────────────────────────
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://saebilymmztfmelppvhn.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNhZWJpbHltbXp0Zm1lbHBwdmhuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ5MTg2MTMsImV4cCI6MjA5MDQ5NDYxM30.FYoL1oFq5Ec5f4-vm29T4Cp9UmjBHu_M5gozNxPPK3k',
  );

  // ── 웹앱 API 설정 ──────────────────────────────────
  static const String webApiBaseUrl = String.fromEnvironment(
    'WEB_API_BASE_URL',
    defaultValue: 'https://guda-chatbot.vercel.app',
  );

  // ── 구글 로그인 설정 ────────────────────────────────
  static const String googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
    defaultValue: '575817137306-o114r5ntdvj65qrvdn7butcrjjjondff.apps.googleusercontent.com',
  );

  // ── 앱 메타데이터 ─────────────────────────────────
  static const String appName = 'Guda';
  static const String appVersion = '1.0.0';
}
