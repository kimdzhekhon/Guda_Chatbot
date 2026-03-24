/// Guda 앱 환경 설정
/// TODO: 운영 배포 전 환경변수(--dart-define)로 분리 필요
abstract final class AppConfig {
  // ── Supabase 설정 ─────────────────────────────────
  /// Supabase 프로젝트 URL
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );

  /// Supabase anon key (공개 키, 비밀 키 아님)
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key',
  );

  // ── Edge Functions 엔드포인트 ─────────────────────
  /// 팔만대장경 RAG 채팅 Edge Function
  static const String tripitakaChatFunction = 'tripitaka-chat';

  /// 주역 RAG 채팅 Edge Function
  static const String ichingChatFunction = 'iching-chat';

  /// 구사론 RAG 채팅 Edge Function
  static const String abhidharmaChatFunction = 'abhidharma-chat';

  // ── 앱 메타데이터 ─────────────────────────────────
  static const String appName = 'Guda';
  static const String appVersion = '1.0.0';
}
