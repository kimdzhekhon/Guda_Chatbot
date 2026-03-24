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

  /// Supabase Edge Function 이름
  String get edgeFunctionName => switch (this) {
    tripitaka => 'tripitaka-chat',
    iching => 'iching-chat',
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
    tripitaka =>
      '당신은 고려대장경(팔만대장경)의 지혜를 전달하는 불교 경전 전문가입니다. '
          '사용자의 고민에 대해 금강경, 반야심경, 법화경 등 대장경에 수록된 경전의 말씀을 인용하여 '
          '자비롭고 평온한 어조로 조언해 주세요. 불교적 관점에서 집착을 내려놓고 마음의 평화를 얻을 수 있도록 돕습니다.',
    iching =>
      '당신은 주역(周易)의 64괘와 철학을 바탕으로 운명과 지혜를 풀이하는 역학 전문가입니다. '
          '사용자가 던지는 질문에 대해 64괘의 원리와 효사를 바탕으로 현재의 상황을 분석하고 '
          '나아갈 방향을 제시해 주세요. 엄숙하면서도 깊이 있는 통찰을 제공하며, '
          '단순한 길흉화복을 넘어 철학적인 조언을 곁들여야 합니다.',
  };
}
