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
  static const String deleteAccountWarning = '구매내역, 채팅 기록 등 모든 데이터가\n영구적으로 삭제되며 복구가 불가능합니다.';
  static const String deleteAccountCheckbox = '위 내용을 확인했으며, 탈퇴에 동의합니다.';

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
  static const String reRegistrationForbiddenTitle = '재가입 제한 안내';
  static const String errCodeReRegistrationForbidden = 'AUTH_RE_REGISTRATION_FORBIDDEN';
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
  static const String termsOfServiceContent = '''
제 1 조 (목적)
본 약관은 Guda(이하 "서비스")가 제공하는 인공지능 챗봇 서비스 및 관련 제반 서비스의 이용과 관련하여 서비스와 회원 사이의 권리, 의무 및 책임사항, 기타 필요한 사항을 규정함을 목적으로 합니다.

제 2 조 (정의)
① "서비스"란 Guda가 제공하는 동양 고전(팔만대장경, 주역) 기반 AI 챗봇 서비스 및 이에 부수하는 일체의 서비스를 말합니다.
② "회원"이란 본 약관에 동의하고 소셜 로그인(Google, Apple)을 통해 이용 계약을 체결한 자를 말합니다.
③ "대화 크레딧"이란 서비스 내 AI 대화를 이용하기 위해 필요한 이용권을 말합니다.

제 3 조 (약관의 효력 및 변경)
① 본 약관은 회원이 동의함으로써 효력이 발생합니다.
② 서비스는 관련 법령에 위배되지 않는 범위 내에서 약관을 변경할 수 있으며, 변경 시 적용일 7일 전부터 앱 내 공지합니다.
③ 변경된 약관에 동의하지 않을 경우 회원은 이용 계약을 해지할 수 있습니다.

제 4 조 (이용 계약의 성립)
① 이용 계약은 회원이 본 약관에 동의하고 소셜 로그인을 완료한 시점에 성립됩니다.
② 서비스는 다음 각 호에 해당하는 경우 이용 신청을 거부하거나 사후에 이용 계약을 해지할 수 있습니다.
  1. 타인의 정보를 도용한 경우
  2. 탈퇴 후 30일 이내에 재가입을 시도한 경우
  3. 기타 서비스의 정상적인 운영을 방해하는 경우

제 5 조 (이용 연령 제한)
① 서비스는 만 14세 이상의 이용자만 가입할 수 있습니다.
② 만 14세 미만의 아동이 서비스에 가입한 사실이 확인될 경우, 서비스는 해당 계정을 즉시 해지하고 관련 데이터를 삭제할 수 있습니다.

제 6 조 (서비스의 내용)
① 서비스는 다음과 같은 기능을 제공합니다.
  1. 팔만대장경 기반 AI 대화: 불교 경전의 지혜를 바탕으로 한 AI 상담
  2. 주역 기반 AI 대화: 64괘의 철학을 바탕으로 한 AI 운세 풀이 및 조언
  3. AI 페르소나 선택: 기본, 친절한, 직설적인 대화 스타일 선택
  4. 북마크 기능: 대화 내용 및 괘 저장
② 서비스는 AI 기술을 활용하며, AI가 생성한 응답은 참고용 정보로서 전문적인 종교·철학·의료·법률 상담을 대체하지 않습니다.

제 7 조 (대화 크레딧 및 결제)
① 서비스 이용에는 대화 크레딧이 필요하며, 회원은 메시지 1건당 1크레딧을 소비합니다.
② 크레딧은 다음의 방법으로 획득할 수 있습니다.
  1. 무료 체험: 신규 가입 시 제공되는 무료 크레딧
  2. 정기 구독: 월간 또는 연간 구독을 통한 크레딧 지급
  3. 단일 충전: 일회성 크레딧 구매
③ 유료 결제에 관한 사항은 앱 내 결제 화면에 표시된 조건에 따릅니다.
④ 환불은 관련 법령 및 앱스토어(Apple App Store, Google Play Store)의 환불 정책에 따릅니다.

제 8 조 (회원의 의무)
회원은 다음 각 호의 행위를 하여서는 안 됩니다.
  1. 서비스를 이용하여 법령 또는 공서양속에 반하는 내용을 생성·유포하는 행위
  2. AI 응답을 전문적 조언(의료, 법률, 재무 등)으로 오인하여 중요한 의사결정에 단독 근거로 사용하는 행위
  3. 서비스의 기술적 보호 조치를 우회하거나 무력화하는 행위
  4. 자동화 도구를 이용하여 서비스에 과도한 부하를 주는 행위
  5. 타인의 계정을 무단으로 사용하는 행위

제 9 조 (지적재산권 및 AI 생성 콘텐츠)
① 서비스에 포함된 소프트웨어, 디자인, 로고, 텍스트 등 일체의 콘텐츠에 대한 지적재산권은 서비스 운영자에게 귀속됩니다.
② AI가 생성한 대화 응답에 대해 서비스는 독점적 권리를 주장하지 않으며, 회원은 해당 응답을 개인적 용도로 자유롭게 활용할 수 있습니다.
③ 회원은 AI 응답을 상업적으로 재판매하거나, 서비스의 콘텐츠를 무단 복제·배포할 수 없습니다.

제 10 조 (서비스의 변경·중단)
① 서비스는 운영상 또는 기술상의 필요에 따라 서비스 내용을 변경하거나 일시적으로 중단할 수 있습니다.
② 천재지변, 시스템 장애 등 불가항력으로 인한 서비스 중단에 대해서는 책임을 지지 않습니다.

제 11 조 (계정 탈퇴 및 데이터 처리)
① 회원은 언제든지 앱 내 설정에서 계정 탈퇴를 요청할 수 있습니다.
② 탈퇴 시 회원의 프로필, 대화 내역, 사용 기록, 구독 정보, 북마크가 즉시 삭제됩니다.
③ 결제 내역(거래 기록)은 관련 법령에 따라 보관 후 파기합니다.
④ 탈퇴 후 30일 이내에는 동일 계정으로 재가입할 수 없습니다.

제 12 조 (면책 조항)
① 서비스가 제공하는 AI 응답은 동양 고전을 학습한 인공지능이 생성한 것으로, 정확성·완전성을 보장하지 않습니다.
② AI 응답을 근거로 한 회원의 판단 및 행동에 대해 서비스는 책임을 지지 않습니다.
③ 서비스는 회원 간 또는 회원과 제3자 간의 분쟁에 개입하지 않으며 이에 대한 책임을 지지 않습니다.

제 13 조 (준거법 및 관할)
본 약관의 해석 및 분쟁 해결에 관하여는 대한민국 법률을 적용하며, 분쟁 발생 시 서울중앙지방법원을 제1심 관할 법원으로 합니다.

부칙
본 약관은 2025년 1월 1일부터 시행합니다.
''';

  static const String privacyPolicyContent = '''
Guda 개인정보처리방침

1. 개인정보의 수집 항목 및 수집 방법

가. 수집 항목
[필수] 이메일 주소, 닉네임, 프로필 사진 URL (소셜 로그인 제공 정보)
[자동 생성] 계정 생성일시, 서비스 이용 기록(대화 내역, 크레딧 사용 기록), 결제 기록

나. 수집 방법
- 소셜 로그인(Google, Apple) 시 해당 플랫폼이 제공하는 정보를 수집합니다.
- 서비스 이용 과정에서 자동으로 생성되는 정보를 수집합니다.

2. 개인정보의 수집 및 이용 목적

가. 서비스 제공 및 운영
- 회원 식별 및 인증, AI 대화 서비스 제공
- 대화 크레딧 관리 및 구독·결제 처리
- 대화 기록 저장 및 북마크 기능 제공

나. 서비스 개선
- 서비스 품질 향상 및 신규 기능 개발을 위한 통계 분석 (비식별 처리)

3. 개인정보의 보유 및 이용 기간

가. 회원 탈퇴 시 즉시 삭제되는 정보
- 프로필 정보, 대화 내역, 대화방 정보, 크레딧 사용 기록, 구독 정보, 북마크

나. 일정 기간 보관 후 파기하는 정보
- 결제 및 거래 기록: 전자상거래법에 따라 5년간 보관
- 탈퇴 계정 정보(이메일, 로그인 방식): 재가입 방지를 위해 30일간 보관 후 파기

4. 개인정보의 제3자 제공

서비스는 원칙적으로 회원의 개인정보를 제3자에게 제공하지 않습니다. 다만, 다음의 경우는 예외로 합니다.
- 회원이 사전에 동의한 경우
- 법령에 의거하여 수사 목적으로 관계 기관의 요청이 있는 경우

5. 개인정보 처리 위탁

서비스는 원활한 서비스 제공을 위해 다음과 같이 개인정보 처리를 위탁하고 있습니다.

| 수탁업체 | 위탁 업무 |
| Supabase Inc. | 데이터베이스 호스팅, 회원 인증 관리 |
| Anthropic | AI 대화 응답 생성 (대화 내용 전송) |
| Google LLC | 소셜 로그인 인증 |
| Apple Inc. | 소셜 로그인 인증 |

6. 회원의 권리 및 행사 방법

회원은 언제든지 다음의 권리를 행사할 수 있습니다.
- 개인정보 열람 요청
- 개인정보 수정 요청 (앱 내 프로필 설정)
- 계정 탈퇴를 통한 개인정보 삭제 요청 (앱 내 설정 > 계정 탈퇴)
- 개인정보 처리 정지 요청

7. 개인정보의 안전성 확보 조치

서비스는 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다.
- 데이터베이스 접근 제어(Row-Level Security) 적용
- 인증 토큰의 안전한 저장 (iOS Keychain / Android Keystore)
- SSL/TLS 암호화 통신
- 서비스 접근 권한 최소화 원칙 적용

8. 개인정보 보호 책임자

개인정보 보호 책임 관련 문의는 아래 연락처로 문의해 주시기 바랍니다.
- 서비스명: Guda
- 이메일: [문의 이메일 주소]

9. 고지 의무

본 개인정보처리방침은 법령·정책 또는 서비스 변경에 따라 변경될 수 있으며, 변경 시 앱 내 공지사항을 통해 안내합니다.

시행일: 2025년 1월 1일
''';
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
