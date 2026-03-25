import 'package:guda_chatbot/core/constants/app_strings.dart';

/// 3대 고전 분류 — 주요 기능 도메인 식별자 (구사론은 팔만대장경에 편입)
enum ClassicType {
  /// 팔만대장경 (Tripitaka Koreana) — 불교 경전집
  tripitaka,

  /// 주역 (I Ching) — 유교 오경, 64괘 철학
  iching;

  /// 표시 이름
  String get displayName => switch (this) {
    tripitaka => AppStrings.tripitakaDomainName,
    iching => AppStrings.ichingDomainName,
  };

  /// 설명
  String get description => switch (this) {
    tripitaka => AppStrings.tripitakaDomainDesc,
    iching => AppStrings.ichingDomainDesc,
  };

  /// API 엔드포인트 경로 (Next.js 웹앱)
  String get apiPath => switch (this) {
    tripitaka => '/api/chat/tripitaka',
    iching => '/api/chat/zhouyi',
  };

  /// AI 응답 구조 단계 수 (팔만대장경: 2단계, 주역: 3단계)
  int get responseSteps => switch (this) {
    tripitaka => 2,
    iching => 3,
  };

  /// 대화 시작 안내 메시지
  String get guidanceMessage => switch (this) {
    tripitaka => AppStrings.tripitakaGuidance,
    iching => AppStrings.ichingGuidance,
  };

  /// AI 시스템 프롬프트 (페르소나 설정)
  String get systemPrompt => switch (this) {
    tripitaka => AppStrings.tripitakaSystemPrompt,
    iching => AppStrings.ichingSystemPrompt,
  };
}
