import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_menu_button.dart';

/// 약관 동의 바텀시트 (오류 수정을 위한 단순화 버전)
class GudaTermsBottomSheet extends StatefulWidget {
  const GudaTermsBottomSheet({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const GudaTermsBottomSheet(),
    );
  }

  @override
  State<GudaTermsBottomSheet> createState() => _GudaTermsBottomSheetState();
}

class _GudaTermsBottomSheetState extends State<GudaTermsBottomSheet> {
  bool _isTermsAgreed = false;
  bool _isPrivacyAgreed = false;
  bool _isTermsExpanded = false;
  bool _isPrivacyExpanded = false;

  bool get _isAllAgreed => _isTermsAgreed && _isPrivacyAgreed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Material( // 명시적으로 Material 감싸기
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(GudaSpacing.lg),
          ),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: EdgeInsets.fromLTRB(
          GudaSpacing.xl,
          GudaSpacing.xl,
          GudaSpacing.xl,
          GudaSpacing.xl + bottomPadding,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '서비스 이용 약관 동의',
                style: GudaTypography.heading3(color: colorScheme.onSurface),
              ),
              const SizedBox(height: GudaSpacing.xs),
              Text(
                '약관을 펼쳐서 확인해야 동의할 수 있습니다.',
                style: GudaTypography.caption(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: GudaSpacing.lg),

              // 이용약관
              _buildExpandableRow(
                label: AppStrings.termsRequired,
                content: _tempTermsContent,
                value: _isTermsAgreed,
                isExpanded: _isTermsExpanded,
                onChanged: (val) {
                  setState(() {
                    _isTermsAgreed = val ?? false;
                    if (val == true) _isTermsExpanded = false;
                  });
                },
                onToggle: () => setState(() => _isTermsExpanded = !_isTermsExpanded),
                colorScheme: colorScheme,
              ),

              // 개인정보처리방침
              _buildExpandableRow(
                label: AppStrings.privacyRequired,
                content: _tempPrivacyContent,
                value: _isPrivacyAgreed,
                isExpanded: _isPrivacyExpanded,
                onChanged: (val) {
                  setState(() {
                    _isPrivacyAgreed = val ?? false;
                    if (val == true) _isPrivacyExpanded = false;
                  });
                },
                onToggle: () => setState(() => _isPrivacyExpanded = !_isPrivacyExpanded),
                colorScheme: colorScheme,
              ),

              const SizedBox(height: GudaSpacing.xl),

              // 시작하기 버튼
              GudaMenuButton(
                onPressed: _isAllAgreed ? () => Navigator.pop(context, true) : null,
                label: AppStrings.startWithGuda,
                backgroundColor: _isAllAgreed ? GudaColors.primary : colorScheme.surfaceContainerHighest,
                foregroundColor: _isAllAgreed ? Colors.white : colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableRow({
    required String label,
    required String content,
    required bool value,
    required bool isExpanded,
    required ValueChanged<bool?> onChanged,
    required VoidCallback onToggle,
    required ColorScheme colorScheme,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: Text(label, style: GudaTypography.body2(color: colorScheme.onSurface)),
                value: value,
                activeColor: GudaColors.primary,
                onChanged: (isExpanded || value) ? onChanged : null, // 펼쳐져 있거나 이미 동의한 상태면 체크 해제 가능
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            IconButton(
              onPressed: onToggle,
              icon: Icon(
                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        if (isExpanded)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(GudaSpacing.md),
            margin: const EdgeInsets.only(bottom: GudaSpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: GudaRadius.mdAll,
            ),
            child: Text(
              content,
              style: GudaTypography.caption2(color: colorScheme.onSurface),
            ),
          ),
      ],
    );
  }

  static const String _tempTermsContent = '''
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

  static const String _tempPrivacyContent = '''
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

개인정보 보호 관련 문의는 아래 연락처로 문의해 주시기 바랍니다.
- 서비스명: Guda
- 이메일: [문의 이메일 주소]

9. 고지 의무

본 개인정보처리방침은 법령·정책 또는 서비스 변경에 따라 변경될 수 있으며, 변경 시 앱 내 공지사항을 통해 안내합니다.

시행일: 2025년 1월 1일
''';
}
