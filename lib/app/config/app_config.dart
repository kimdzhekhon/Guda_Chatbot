/// Guda 앱 환경 설정
/// TODO: 운영 배포 전 환경변수(--dart-define)로 분리 필요
abstract final class AppConfig {
  // ── Supabase 설정 ─────────────────────────────────
  /// Supabase 프로젝트 URL
  /// TODO: 실제 Supabase 프로젝트 URL로 교체
  static const String supabaseUrl = 'https://your-project.supabase.co';

  /// Supabase anon key (공개 키, 비밀 키 아님)
  /// TODO: 실제 Supabase anon key로 교체
  static const String supabaseAnonKey = 'your-anon-key';

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
