import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_animations.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_button.dart';
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
        )
            .gudaFadeIn(duration: const Duration(milliseconds: 400))
            .gudaSlideIn(begin: const Offset(0, 0.05)),
        const SizedBox(height: GudaSpacing.xl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.xl),
          child: GudaButton.filled(
            label: _isLoading ? '대화 생성 중...' : '새 대화 시작',
            onPressed: () async {
              setState(() => _isLoading = true);
              await Future.delayed(const Duration(milliseconds: 500));
              if (mounted) {
                ref.read(homeViewModelProvider.notifier).startNewChat();
                setState(() => _isLoading = false);
              }
            },
            icon: _isLoading ? null : Icons.chat_bubble_outline,
            isLoading: _isLoading,
            isFullWidth: true,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? GudaColors.accent
                : null, // null defaults to cs.primary (Indigo)
            foregroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : null,
          ),
        )
            .gudaFadeIn(delay: const Duration(milliseconds: 200))
            .gudaScaleIn(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
            ),
      ],
    );
  }
}
