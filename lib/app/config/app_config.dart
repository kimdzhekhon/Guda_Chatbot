/// Guda 앱 환경 설정
/// TODO: 운영 배포 전 환경변수(--dart-define)로 분리 필요
abstract final class AppConfig {
  // ── Supabase 설정 ─────────────────────────────────
  static const String supabaseUrl = 'https://saebilymmztfmelppvhn.supabase.co';

  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNhZWJpbHltbXp0Zm1lbHBwdmhuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ5MTg2MTMsImV4cCI6MjA5MDQ5NDYxM30.FYoL1oFq5Ec5f4-vm29T4Cp9UmjBHu_M5gozNxPPK3k';


  // ── 웹앱 API 설정 ──────────────────────────────────
  /// Next.js 웹앱 베이스 URL (채팅 API 호출용)
  static const String webApiBaseUrl = 'https://guda-chatbot.vercel.app';

  // ── 구글 로그인 설정 ────────────────────────────────
  /// iOS용 Google Client ID
  static const String googleIosClientId =
      '575817137306-o114r5ntdvj65qrvdn7butcrjjjondff.apps.googleusercontent.com';

  // ── 앱 메타데이터 ─────────────────────────────────
  static const String appName = 'Guda';
  static const String appVersion = '1.0.0';
}
