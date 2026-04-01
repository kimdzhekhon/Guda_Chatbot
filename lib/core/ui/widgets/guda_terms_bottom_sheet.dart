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
... (중략)
''';

  static const String _tempPrivacyContent = '''
1. 개인정보 수집항목
- 수집항목: 이메일 주소, 닉네임, 프로필 사진 (소셜 로그인 시 제공되는 정보)
... (중략)
''';
}
