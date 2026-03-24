/// 앱 내 고정 문자열 상수
abstract final class AppStrings {
  // ── 봇 선택 프롬프트 / 홈 화면 ───────────────────
  static const String botSelectionTitle = '동양 고전 AI 대화';
  static const String botSelectionSubtitle = '불교와 유교 경전에 대해 AI와 대화하세요';

  // 팔만대장경 카드
  static const String tripitakaName = '팔만대장경';
  static const String tripitakaDesc = '고려대장경, 불교 경전의 집대성';
  static const String tripitakaContentsSubtitle = '수록 경전';
  static const String tripitakaContents1 = '화엄경(60권·80권) · 금강경 · 반야심경';
  static const String tripitakaContents2 = '법화경 · 무량수경 · 아미타경 · 유마경';
  static const String tripitakaContents3 = '약사경 · 원각경 · 능가경 · 구사론';

  // 주역 카드
  static const String ichingName = '주역(周易)';
  static const String ichingDesc = '유교 오경 중 하나, 64괘와 384효의 지혜';
  static const String ichingContentsSubtitle = '수록 내용';
  static const String ichingContents1 = '상경 30괘 · 하경 34괘';
  static const String ichingContents2 = '단전 · 상전 · 계사전';

  // ── 대화 목록 화면 ──────────────────────────────
  static const String appName = 'Guda';
  static const String loadingChatList = '대화 목록 불러오는 중...';
  static const String newChat = '새 대화';
  static const String emptyChatTitle = '아직 대화가 없습니다\n아래 버튼으로 새 대화를 시작해보세요';

  // ── 고전 도메인 설명 ─────────────────────────────
  static const String tripitakaDomainName = '팔만대장경';
  static const String ichingDomainName = '주역';

  static const String tripitakaDomainDesc = '화엄경, 금강경 등 불교 경전의 집대성';
  static const String ichingDomainDesc = '64괘와 384효를 통한 철학적 지혜';

  // ── 대화 가이드 (빈 화면 안내) ──────────────────────
  static const String tripitakaGuidance = '고려대장경의 불교 경전에 대해 질문해보세요. 금강경, 반야심경, 법화경 등 다양한 경전에 대해 대화할 수 있습니다.\n\n무엇이 궁금하신가요?';
  static const String ichingGuidance = '점을 치기 전에 질문을 먼저 적어주세요.';

  // ── 초기 질문 카드 (주역 전용 또는 공통) ──────────────
  static const String initialQuestionTitle = '무엇이 궁금하신가요?';
  static const String ichingSelectionTitle = '궤를 선택하세요';
  static const String initialQuestionSubtitle = '점을 치기 전에 질문을 먼저 적어주세요.';
  static const String initialQuestionHint = '예: 이직을 하면';
  static const String initialQuestionSuffix = '길하겠습니까?';
  static const String startDivinationButton = '점 치러 가기';
  static const String skipQuestionButton = '질문 없이 점치기';
  
  static const String selectHexagram = '궤 선택';
  static const String throwHexagram = '궤 던지기';

  // 팔만대장경 초기 질문 카드
  static const String tripitakaInitialTitle = '무엇이 궁금하신가요?';
  static const String tripitakaInitialSubtitle = '고민을 적어주시면 대장경의 말씀으로 답해드립니다.';
  static const String tripitakaStartButton = '대화 시작하기';
  static const String tripitakaSkipButton = '질문 없이 시작하기';
}
