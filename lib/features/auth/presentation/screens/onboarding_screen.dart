import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_scaffold.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_gradient_background.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_text_input_field.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_step_indicator.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_menu_button.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_snack_bar.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';
import 'package:guda_chatbot/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';

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
  bool _hasReadTerms = false; // 약관 확인 여부
  bool _hasReadPrivacy = false; // 개인정보 확인 여부

  // Step 2: Profile
  final TextEditingController _nicknameController = TextEditingController();
  DateTime? _selectedBirthDate;
  String _selectedPersona = 'wise';

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 1) {
      if (!_isTermsAgreed || !_isPrivacyAgreed) {
        GudaSnackBar.show(context, message: '모든 약관에 동의해주세요.', isError: true);
        return;
      }
      setState(() => _currentStep = 2);
    } else if (_currentStep == 2) {
      if (_nicknameController.text.isEmpty || _selectedBirthDate == null) {
        GudaSnackBar.show(context, message: '모든 프로필 정보를 입력해주세요.', isError: true);
        return;
      }
      setState(() => _currentStep = 3);
    } else {
      _submit();
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      // 1단계에서 뒤로가기 시 세션을 로그아웃하고 로그인 화면으로 돌아감
      ref.read(authViewModelProvider.notifier).signOut();
    }
  }

  Future<void> _submit() async {
    // 3단계 진입 시 이미 2단계 검증이 완료된 상태지만, 안전을 위해 재확인
    if (_nicknameController.text.isEmpty || _selectedBirthDate == null) {
      GudaSnackBar.show(context, message: '기본 정보를 모두 입력해주세요.', isError: true);
      setState(() => _currentStep = 2);
      return;
    }

    await ref.read(authViewModelProvider.notifier).updateProfile(
      nickname: _nicknameController.text,
      birthDate: _selectedBirthDate!,
      persona: _selectedPersona,
      termsAgreed: true,
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('ko', 'KR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: context.colorScheme,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedBirthDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authViewModelProvider);
    final isLoading = state.isLoading;

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
                  onPressed: _previousStep, // _previousStep에서 로그아웃 처리
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
                      totalSteps: 3,
                      labels: const ['약관 동의', '기본 정보', '페르소나'],
                    ),
                    const SizedBox(height: GudaSpacing.xxl),
                    Expanded(
                      child: SingleChildScrollView(
                        child: _buildCurrentStepContent(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: GudaSpacing.lg),
              GudaMenuButton(
                onPressed: _nextStep,
                label: _currentStep < 3 ? '다음으로' : '완료',
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
      content: '닉네임, 생년월일, 페르소나 정보를 수집합니다...',
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
                  enabled: true, // 로직에서 안내를 위해 상시 활성 후 onChanged에서 제어
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

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildTermsStep();
      case 2:
        return _buildBasicInfoStep();
      case 3:
        return _buildPersonaStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBasicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '기본 정보를 설정하여\n대화를 시작해보세요',
          style: GudaTypography.heading3(color: Colors.white),
        ),
        const SizedBox(height: GudaSpacing.lg),
        Text('닉네임', style: GudaTypography.captionBold(color: Colors.white70)),
        const SizedBox(height: GudaSpacing.xs),
        GudaTextInputField(
          controller: _nicknameController,
          hintText: '사용하실 닉네임을 입력하세요',
          backgroundColor: Colors.white.withValues(alpha: 0.1),
          border: Border.all(color: Colors.white24),
          style: GudaTypography.input(color: Colors.white),
          hintStyle: GudaTypography.input(color: Colors.white38),
        ),
        const SizedBox(height: GudaSpacing.md),
        Text('생년월일', style: GudaTypography.captionBold(color: Colors.white70)),
        const SizedBox(height: GudaSpacing.xs),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.md, vertical: GudaSpacing.md12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: GudaRadius.lgAll,
              border: Border.all(color: Colors.white24),
            ),
            child: Text(
              _selectedBirthDate == null 
                  ? '날짜를 선택하세요' 
                  : '${_selectedBirthDate!.year}년 ${_selectedBirthDate!.month}월 ${_selectedBirthDate!.day}일',
              style: GudaTypography.input(
                color: _selectedBirthDate == null 
                    ? Colors.white38
                    : Colors.white,
              ),
            ),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPersonaItem('wise', '현명한 현자'),
            const SizedBox(height: GudaSpacing.md12),
            _buildPersonaItem('friendly', '따뜻한 친구'),
            const SizedBox(height: GudaSpacing.md12),
            _buildPersonaItem('strict', '냉철한 분석가'),
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

  Widget _buildPersonaItem(String id, String label) {
    final isSelected = _selectedPersona == id;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedPersona = id),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: GudaSpacing.md,
          vertical: GudaSpacing.md12,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: isSelected ? 0.15 : 0.08),
          borderRadius: GudaRadius.lgAll,
          border: Border.all(
            color: isSelected ? GudaColors.primary : Colors.white24,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? GudaColors.primary : Colors.white38,
              size: 20,
            ),
            const SizedBox(width: GudaSpacing.sm),
            Text(
              label,
              style: isSelected
                  ? GudaTypography.body1Bold(color: Colors.white)
                  : GudaTypography.body1(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
