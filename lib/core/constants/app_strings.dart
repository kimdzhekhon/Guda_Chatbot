import 'package:guda_chatbot/app/config/app_config.dart';

/// Guda 앱 모든 문자열 관리 (한글 공식 문서화 준수)
abstract final class AppStrings {
  // ── 공통 ─────────────────────────────────────
  static const String appTitle = AppConfig.appName;
  static const String appName = AppConfig.appName;
  static const String error = '오류';
  static const String errorPrefix = '오류가발생했습니다:';
  static const String retryLabel = '다시 시도';

  // ── 스플래시 ──────────────────────────────────
  static const String splashMessage = '동양 고전의 지혜를 깨우다';

  // ── 홈 ──────────────────────────────────────
  static const String welcomeMessage = '안녕하세요, Guda입니다.\n고민을 나누고 지혜를 얻어보세요.';
  static const String classicSelectionTitle = '탐색할 고전을 선택하세요';

  // ── 팔만대장경 ────────────────────────────────
  static const String tripitakaName = '팔만대장경';
  static const String tripitakaDomainName = '팔만대장경';
  static const String tripitakaDesc = '불교 경전의 모든 지혜';
  static const String tripitakaDomainDesc = '불교 경전의 모든 지혜';
  static const String tripitakaGuidance = '마음의 평화와 해탈을 위한 지혜를 드립니다. 궁금한 경전이나 고민을 말씀해 주세요.';
  static const String tripitakaContentsSubtitle = '주요 특징';
  static const String tripitakaContents1 = '8만 1천여 개의 경판';
  static const String tripitakaContents2 = '불교 지혜의 집대성';
  static const String tripitakaContents3 = '유네스코 세계기록유산';

  // ── 주역 ─────────────────────────────────────
  static const String ichingName = '주역 (周易)';
  static const String ichingDomainName = '주역 (周易)';
  static const String ichingDesc = '만물의 변화와 운명의 이치';
  static const String ichingDomainDesc = '만물의 변화와 운명의 이치';
  static const String ichingGuidance = '하늘과 땅의 이치를 통해 현재의 상황을 풀이해 드립니다. 괘를 선택하거나 던져보세요.';
  static const String ichingSelectionTitle = '점괘를 얻는 방식';
  static const String ichingContentsSubtitle = '주요 특징';
  static const String ichingContents1 = '64괘와 384효의 철학';
  static const String ichingContents2 = '변화와 조화의 원리';

  // ── 초기 질문 카드
  static const String initialQuestionTitle = '무엇이 궁금하신가요?';
  static const String initialQuestionSubtitle = '고민을 적어주세요';
  static const String initialQuestionHint = '예: 요즘 진로 고민이 많아요, 마음이 불안해요';
  static const String startDivinationButton = '대화 시작하기';
  static const String skipQuestionButton = '질문 없이 시작하기';

  // 설정
  static const String settingsTitle = '설정';
  static const String darkMode = '다크 모드';
  static const String logout = '로그아웃';
  static const String logoutConfirm = '로그아웃하시겠습니까?';
  static const String cancel = '취소';
  static const String deleteAccount = '계정 탈퇴';
  static const String deleteAccountConfirmTitle = '계정 탈퇴';
  static const String deleteAccountConfirmMessage = '계정을 탈퇴하시겠습니까?\n모든 데이터가 삭제되며 복구할 수 없습니다.';

  // 채팅
  static const String chatInputHint = '메시지를 입력하세요...';
  static const String remainingChatCount = '잔여 대화: ';
  static const String countUnit = '회';
  static const String messageLoadFail = '메시지를 불러오는 데 실패했습니다.';
  static const String messageSendFail = '메시지 전송에 실패했습니다.';
  static const String conversationLoadFail = '대화 목록을 불러오는 데 실패했습니다.';
  static const String conversationCreateFail = '대화 생성에 실패했습니다.';
  static const String conversationDeleteFail = '대화 삭제에 실패했습니다.';
  static const String deleteConversationTitle = '대화 삭제';
  static const String deleteConversationMessage = '정말 이 대화를 삭제하시겠습니까?\n삭제된 대화는 복구할 수 없습니다.';
  static const String deleteLabel = '삭제';
  static const String aiAdviceTitle = 'Guda AI의 조언';
  static const String aiAdviceMsg = 'Guda AI가 전하는 고전의 지혜입니다.';
  static const String shareAsImage = '이미지로 공유하기';

  // 주역 64괘 관련
  static const String selectHexagram = '궤 선택';
  static const String throwHexagram = '궤 던지기';

  // 팔만대장경 초기 질문 카드
  static const String tripitakaInitialTitle = '무엇이 궁금하신가요?';
  static const String tripitakaInitialSubtitle = '고민을 적어주시면 대장경의 말씀으로 답해드립니다.';
  static const String tripitakaStartButton = '대화 시작하기';
  static const String tripitakaSkipButton = '질문 없이 시작하기';

  // 팔만대장경 상세 가이드
  static const String tripitakaDetailedGuide =
      '고려대장경의 불교 경전에 대해 질문해보세요. 금강경, 반야심경,\n법화경 등 다양한 경전에 대해 대화할 수 있습니다.';
  static const String tripitakaQuestionHint = '경전에 대해 궁금한 점을 적어주세요';

  // 시스템 프롬프트 (페르소나)
  static const String tripitakaSystemPrompt =
      '당신은 고려대장경(팔만대장경)의 지혜를 전달하는 불교 경전 전문가입니다. '
      '사용자의 고민에 대해 금강경, 반야심경, 법화경 등 대장경에 수록된 경전의 말씀을 인용하여 '
      '자비롭고 평온한 어조로 조언해 주세요. 불교적 관점에서 집착을 내려놓고 마음의 평화를 얻을 수 있도록 돕습니다.';

  static const String ichingSystemPrompt =
      '당신은 주역(周易)의 64괘와 철학을 바탕으로 운명과 지혜를 풀이하는 역학 전문가입니다. '
      '사용자가 던지는 질문에 대해 64괘의 원리와 효사를 바탕으로 현재의 상황을 분석하고 '
      '나아갈 방향을 제시해 주세요. 엄숙하면서도 깊이 있는 통찰을 제공하며, '
      '단순한 길흉화복을 넘어 철학적인 조언을 곁들여야 합니다.';

  // 공통 UI 문구
  static const String brandName = 'G u d a';
  static const String processing = '처리 중...';
  static const String loadingChatList = '목록 로딩 중...';
  static const String noConversations = '아직 대화가 없습니다';
  static const String newChat = '새 채팅';
  static const String historyHeader = '대화 기록';

  // 인증 에러
  static const String googleSignInError = 'Google 로그인에 실패했습니다';
  static const String appleSignInError = 'Apple 로그인에 실패했습니다';
  static const String profileUpdateError = '프로필 업데이트에 실패했습니다';
  static const String logoutError = '로그아웃 중 오류가 발생했습니다';
  static const String noCreditMessage = '남은 대화 횟수가 없습니다. 추가 대화권을 구매해 주세요.';
  static const String messageSendError = '죄송합니다. 메시지 전송 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.';

  // 인증 화면
  static const String authSubtitle = '팔만대장경 · 주역 · 구사론';
  static const String authTitleLine1 = '깊이 있는 지혜의 문답';
  static const String authTitleLine2 = '불교 고전을 학습한 AI 챗봇, Guda';
  static const String authDesc = '고전 AI 챗봇 Guda와 함께\n불교의 가르침을 탐구합니다.';
  static const String continueWithGoogle = 'Google로 계속하기';
  static const String continueWithApple = 'Apple로 계속하기';
  static const String termsOfService = '이용약관';
  static const String privacyPolicy = '개인정보처리방침';
  static const String agreeToAll = '전체 동의하기';
  static const String termsRequired = '(필수) 이용약관';
  static const String privacyRequired = '(필수) 개인정보처리방침';
  static const String startWithGuda = 'Guda 시작하기';
  static const String version = 'Guda v1.0.0';

  // 주역 관련
  static const String ichingThrowing = '괘를 던지는 중입니다...';
  static const String aiWisdomLabel = 'AI 지혜';
  static const String copyrightSuffix = 'Guda. All rights reserved.';
  static const String selectHexagramLabel = '괘 직접 선택';
  static const String selectHexagramDesc = '64괘 중 하나를 직접 선택하거나 검색해보세요.';
  static const String analyzingHexagram = '괘를 분석하고 있습니다.';
  static const String ichingThrowingMsg = '괘를 던지는 중입니다...';

  // 설정 화면
  static const String settingLabel = '설정';
  static const String userNamePlaceholder = '이름 없음';
  static const String appVersionLabel = '버전';
  static const String logoutConfirmTitle = '로그아웃';
  static const String logoutConfirmMessage = '로그아웃 하시겠습니까?';
  static const String confirmLabel = '확인';
  static const String licenseLabel = '오픈소스 라이선스';
  static const String themeLabel = '다크 모드 설정';
  static const String systemThemeLabel = '시스템 설정';
  static const String lightThemeLabel = '라이트 모드';
  static const String darkThemeLabel = '다크 모드';
  static const String closeLabel = '닫기';
  static const String bookmarksTitle = '보관함';
  static const String noticeTitle = '공지사항';
  static const String noBookmarksMessage = '아직 저장된 북마크가 없습니다.';

  // 섹션 헤더
  static const String profileSection = '프로필';
  static const String appInfoSection = '앱 정보';
  static const String accountSection = '계정 관리';
  static const String appSettingsSection = '앱 설정';

  // 글자 크기 조절
  static const String fontSizeLabel = '글자 크기';
  static const String fontSizeScreenTitle = '글자 크기 조절';
  static const String fontSizePreviewText = '가나다라마바사 아자차카타파하\n동양 고전의 지혜를 깨우다, Guda';
  static const String fontSizeSmall = '작게';
  static const String fontSizeNormal = '보통';
  static const String fontSizeLarge = '크게';
  static const String purchaseHistoryLabel = '구매 내역';
  static const String usageHistoryLabel = '사용 내역';
  static const String billingSection = '결제 및 이용';
  static const String membershipChargeTitle = '멤버십 & 충전';
  static const String membershipChargeDesc = '당신에게 가장 잘 맞는 지혜의 여정을 선택하세요';
  static const String subscriptionTypeLabel = '정기 구독형';
  static const String chargeTypeLabel = '단일 충전형';
  static const String planSelectionSuffix = '선택 완료';

  // 페르소나 설정
  static const String personaSettingTitle = '페르소나 설정';
  static const String personaSettingDesc = 'AI의 대화 스타일을 선택하세요';
  static const String personaWiseName = '기본';
  static const String personaWiseDesc = '차분하고 격식 있는 어조로 깊이 있는 지혜를 전합니다.';
  static const String personaFriendlyName = '친절한';
  static const String personaFriendlyDesc = '다정하고 따뜻한 어조로 위로와 격려를 건넵니다.';
  static const String personaStrictName = '직설적인';
  static const String personaStrictDesc = '핵심을 짚어 간결하고 명확하게 상황을 분석합니다.';

  // ── 추천 질문 ──────────────────────────────────
  static const List<String> ichingSuggestions = [
    '오늘의 전체적인 운세는?',
    '사업 확장이나 투자 시기로 좋을까?',
    '새로운 프로젝트를 시작해도 될까?',
    '금전운이 궁금해요',
    '학업운/취업운이 어떨까?',
    '대인관계 고민이 있어요',
  ];

  static const List<String> tripitakaSuggestions = [
    '마음이 불안할 때 읽기 좋은 구절',
    '지혜로운 삶이란 무엇인가요?',
    '고통에서 벗어나는 법',
    '인간관계에 대한 부처님의 조언',
    '진정한 행복을 찾는 법',
  ];
}
