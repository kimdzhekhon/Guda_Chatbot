import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/ui/layout/app_responsive_layout.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/home_viewmodel.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/classic_card.dart';

class ClassicCardSlider extends ConsumerStatefulWidget {
  const ClassicCardSlider({super.key});

  @override
  ConsumerState<ClassicCardSlider> createState() => _ClassicCardSliderState();
}

class _ClassicCardSliderState extends ConsumerState<ClassicCardSlider> {
  late PageController _pageController;
  int _currentIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final initialType = ref.read(homeViewModelProvider).selectedClassicType;
    _currentIndex = initialType == ClassicType.tripitaka ? 0 : 1;
    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: 0.85,
    );
  }

  @override
  void didUpdateWidget(covariant ClassicCardSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (_isLoading) return;
    setState(() {
      _currentIndex = index;
    });
    final type = index == 0 ? ClassicType.tripitaka : ClassicType.iching;
    ref.read(homeViewModelProvider.notifier).selectClassicType(type);
  }

  @override
  Widget build(BuildContext context) {
    return AppResponsiveLayout(
      mobile: (context, data) => _buildSlider(data, 0.85, 480),
      tablet: (context, data) => _buildSlider(data, 0.6, 520),
      desktop: (context, data) => _buildSlider(data, 0.4, 560),
    );
  }

  Widget _buildSlider(
    AppResponsiveLayoutData data,
    double viewportFraction,
    double height,
  ) {
    // 컨트롤러 뷰포트가 다르면 새로 생성하되, 빌드 중 직접 할당하지 않고 리턴값으로 사용하거나 관리 개선
    // 여기서는 기존 컨트롤러를 최대한 활용

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── 카드 슬라이더 ────────────────────────────
        SizedBox(
          height: height,
          child: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: _isLoading ? const NeverScrollableScrollPhysics() : null,
            children: [
              ClassicCard(
                type: ClassicType.tripitaka,
                title: AppStrings.tripitakaName,
                description: AppStrings.tripitakaDesc,
                contentsSubtitle: AppStrings.tripitakaContentsSubtitle,
                contents: const [
                  AppStrings.tripitakaContents1,
                  AppStrings.tripitakaContents2,
                  AppStrings.tripitakaContents3,
                ],
              ),
              ClassicCard(
                type: ClassicType.iching,
                title: AppStrings.ichingName,
                description: AppStrings.ichingDesc,
                contentsSubtitle: AppStrings.ichingContentsSubtitle,
                contents: const [
                  AppStrings.ichingContents1,
                  AppStrings.ichingContents2,
                ],
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0),

        const SizedBox(height: GudaSpacing.xl),

        // ── 새 대화 시작 버튼 ────────────────────────
        Padding(
              padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.xl),
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() => _isLoading = true);
                        // Mock 모드: 즉시 상태 업데이트
                        await Future.delayed(const Duration(milliseconds: 500));
                        if (mounted) {
                          ref
                              .read(homeViewModelProvider.notifier)
                              .startNewChat();
                          setState(() => _isLoading = false);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: GudaColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: GudaRadius.lgAll),
                  elevation: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    else
                      const Icon(Icons.chat_bubble_outline),
                    const SizedBox(width: GudaSpacing.sm),
                    Text(
                      _isLoading ? '대화 생성 중...' : '새 대화 시작',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .animate()
            .fadeIn(delay: 200.ms)
            .scale(duration: 300.ms, curve: Curves.easeOutBack),
      ],
    );
  }
}
