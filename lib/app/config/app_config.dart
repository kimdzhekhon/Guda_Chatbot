/// Guda 앱 환경 설정
/// TODO: 운영 배포 전 환경변수(--dart-define)로 분리 필요
abstract final class AppConfig {
  // ── Supabase 설정 ─────────────────────────────────
  static const String supabaseUrl = 'https://sepnrqzjccjrtssvytow.supabase.co';

  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNlcG5ycXpqY2NqcnRzc3Z5dG93Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMxOTk4MDUsImV4cCI6MjA3ODc3NTgwNX0.9bSgdRlnjBQtAMNqoUAjIk8ZVd8WbzgQiLM-l-mu_dw';


  // ── 웹앱 API 설정 ──────────────────────────────────
  /// Next.js 웹앱 베이스 URL (채팅 API 호출용)
  static const String webApiBaseUrl = 'https://guda-chatbot.vercel.app';

  // ── 앱 메타데이터 ─────────────────────────────────
  static const String appName = 'Guda';
  static const String appVersion = '1.0.0';
}
