import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_scaffold.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_gradient_background.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_step_indicator.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_menu_button.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_snack_bar.dart';
import 'package:guda_chatbot/features/auth/domain/entities/guda_user.dart';
import 'package:guda_chatbot/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/features/chat/domain/entities/persona_type.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_persona_selector.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentStep = 1;

  // Step 1: Terms
  bool _isTermsAgreed = false;
  bool _isPrivacyAgreed = false;
  bool _isTermsExpanded = false;
  bool _isPrivacyExpanded = false;
  bool _hasReadTerms = false;
  bool _hasReadPrivacy = false;

  // Step 2: Persona
  PersonaType _selectedPersona = PersonaType.basic;

  void _nextStep() {
    if (_currentStep == 1) {
      if (!_isTermsAgreed || !_isPrivacyAgreed) {
        GudaSnackBar.show(context, message: '모든 약관에 동의해주세요.', isError: true);
        return;
      }
      setState(() => _currentStep = 2);
    } else {
      _submit();
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      ref.read(authViewModelProvider.notifier).signOut();
    }
  }

  Future<void> _submit() async {
    await ref.read(authViewModelProvider.notifier).updateProfile(
      persona: _selectedPersona,
      termsAgreed: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authViewModelProvider);
    final isLoading = state.isLoading;

    // 에러 리스너: RPC 실패 시 스낵바로 표시
    ref.listen(authViewModelProvider, (prev, next) {
      if (next is UiError<GudaUser?>) {
        log('[Onboarding] Auth error: ${next.message}', name: 'Onboarding');
        GudaSnackBar.show(context, message: next.message, isError: true);
      }
      if (next is UiSuccess<GudaUser?>) {
        log('[Onboarding] Auth success: user=${next.data?.id}, isProfileComplete=${next.data?.isProfileComplete}', name: 'Onboarding');
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _previousStep();
      },
      child: GudaScaffold(
        isLoading: isLoading,
        background: const GudaGradientBackground(child: SizedBox.expand()),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: _currentStep > 1
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: _previousStep,
                )
              : IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: _previousStep,
                ),
          surfaceTintColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.xl),
          child: Column(
            children: [
              const SizedBox(height: GudaSpacing.xs),
              Expanded(
                child: Column(
                  children: [
                    GudaStepIndicator(
                      currentStep: _currentStep,
                      totalSteps: 2,
                      labels: const ['약관 동의', '페르소나'],
                    ),
                    const SizedBox(height: GudaSpacing.xxl),
                    Expanded(
                      child: SingleChildScrollView(
                        child: _currentStep == 1
                            ? _buildTermsStep()
                            : _buildPersonaStep(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: GudaSpacing.lg),
              GudaMenuButton(
                onPressed: _nextStep,
                label: _currentStep < 2 ? '다음으로' : '완료',
                backgroundColor: GudaColors.primary,
                foregroundColor: Colors.white,
              ),
              const SizedBox(height: GudaSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '서비스 시작을 위해\n약관에 동의해주세요',
          style: GudaTypography.heading3(color: Colors.white),
        ),
        const SizedBox(height: GudaSpacing.lg),
        _buildExpandableRow(
          label: '서비스 이용약관 (필수)',
          content: '본 약관은 구다 서비스 이용을 위한 기본 사항을 규정합니다...',
          value: _isTermsAgreed,
          isExpanded: _isTermsExpanded,
          canAgree: _hasReadTerms,
          onChanged: (val) {
            if (!_hasReadTerms) {
              GudaSnackBar.show(context, message: '약관 상세 내용을 펼쳐서 확인해주세요.', isError: true);
              return;
            }
            setState(() => _isTermsAgreed = val ?? false);
          },
          onToggle: () {
            setState(() {
              _isTermsExpanded = !_isTermsExpanded;
              if (_isTermsExpanded) _hasReadTerms = true;
            });
          },
        ),
        _buildExpandableRow(
          label: '개인정보 수집 및 이용 (필수)',
          content: '페르소나 정보를 수집합니다...',
          value: _isPrivacyAgreed,
          isExpanded: _isPrivacyExpanded,
          canAgree: _hasReadPrivacy,
          onChanged: (val) {
            if (!_hasReadPrivacy) {
              GudaSnackBar.show(context, message: '개인정보 수집 및 이용 상세 내용을 펼쳐서 확인해주세요.', isError: true);
              return;
            }
            setState(() => _isPrivacyAgreed = val ?? false);
          },
          onToggle: () {
            setState(() {
              _isPrivacyExpanded = !_isPrivacyExpanded;
              if (_isPrivacyExpanded) _hasReadPrivacy = true;
            });
          },
        ),
      ],
    );
  }

  Widget _buildExpandableRow({
    required String label,
    required String content,
    required bool value,
    required bool isExpanded,
    required bool canAgree,
    required ValueChanged<bool?> onChanged,
    required VoidCallback onToggle,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: Colors.white60,
                ),
                child: CheckboxListTile(
                  title: Text(label, style: GudaTypography.body2(color: Colors.white)),
                  value: value,
                  activeColor: GudaColors.primary,
                  checkColor: Colors.white,
                  onChanged: onChanged,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  enabled: true,
                ),
              ),
            ),
            IconButton(
              onPressed: onToggle,
              icon: Icon(
                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.white60,
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
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: GudaRadius.mdAll,
            ),
            child: Text(
              content,
              style: GudaTypography.caption2(color: Colors.white70),
            ),
          ),
      ],
    );
  }

  Widget _buildPersonaStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '당신에게 어울리는\n페르소나를 선택해주세요',
          style: GudaTypography.heading3(color: Colors.white),
        ),
        const SizedBox(height: GudaSpacing.lg),
        Text('페르소나 설정', style: GudaTypography.captionBold(color: Colors.white70)),
        const SizedBox(height: GudaSpacing.md12),
        GudaPersonaSelector(
          isDarkBackground: true,
          selectedId: _selectedPersona,
          onSelected: (id) => setState(() => _selectedPersona = id),
          items: const [
            PersonaSelectorItem(id: PersonaType.basic, label: '현명한 현자'),
            PersonaSelectorItem(id: PersonaType.friendly, label: '따뜻한 친구'),
            PersonaSelectorItem(id: PersonaType.strict, label: '냉철한 분석가'),
          ],
        ),
        const SizedBox(height: GudaSpacing.md),
        Text(
          '선택하신 페르소나는 대화의 분위기와\n답변 스타일을 결정합니다.',
          style: GudaTypography.caption(color: Colors.white60),
        ),
      ],
    );
  }
}
