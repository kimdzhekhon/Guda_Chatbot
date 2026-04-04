/// Guda 앱 환경 설정
/// 빌드 시 --dart-define으로 주입: flutter run --dart-define-from-file=.env
/// 프로덕션 빌드 시 CI/CD에서 환경변수로 주입
///
/// NOTE: defaultValue는 개발 편의를 위한 값입니다.
/// Supabase anon key는 RLS로 보호되므로 클라이언트 노출은 설계상 허용됩니다.
/// 단, service_role key는 절대 클라이언트에 포함하지 마세요.
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

  // ── 구글 로그인 설정 ────────────────────────────────
  static const String googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
    defaultValue: '575817137306-o114r5ntdvj65qrvdn7butcrjjjondff.apps.googleusercontent.com',
  );

  // ── 앱 메타데이터 ─────────────────────────────────
  static const String appName = 'Guda';
  static const String appVersion = '1.0.0';
}
