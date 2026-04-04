import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_animations.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/layout/app_responsive_layout.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_page_slider.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/home_viewmodel.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/classic_card.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/classic_start_button.dart';

class ClassicCardSlider extends ConsumerStatefulWidget {
  const ClassicCardSlider({super.key});

  @override
  ConsumerState<ClassicCardSlider> createState() => _ClassicCardSliderState();
}

class _ClassicCardSliderState extends ConsumerState<ClassicCardSlider> {
  // ValueNotifier로 로딩 상태를 분리 → setState 없이 버튼만 리빌드 (전체 슬라이더 리빌드 방지)
  final _isLoading = ValueNotifier(false);

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (_isLoading.value) return;
    final type = index == 0 ? ClassicType.tripitaka : ClassicType.iching;
    ref.read(homeViewModelProvider.notifier).selectClassicType(type);
  }

  Future<void> _handleStart() async {
    _isLoading.value = true;
    try {
      await ref.read(homeViewModelProvider.notifier).startNewChat();
    } finally {
      if (mounted) {
        _isLoading.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialType = ref.read(homeViewModelProvider).selectedClassicType;
    final initialPage = initialType == ClassicType.tripitaka ? 0 : 1;

    return AppResponsiveLayout(
      mobile: (context, data) => _buildSlider(480, initialPage),
      tablet: (context, data) => _buildSlider(520, initialPage),
      desktop: (context, data) => _buildSlider(560, initialPage),
    );
  }

  Widget _buildSlider(double height, int initialPage) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: _isLoading,
          builder: (context, isLoading, child) => GudaPageSlider<_ClassicCardData>(
            items: const [
              _ClassicCardData(
                type: ClassicType.tripitaka,
                title: AppStrings.tripitakaName,
                description: AppStrings.tripitakaDesc,
                contentsSubtitle: AppStrings.tripitakaContentsSubtitle,
                contents: [
                  AppStrings.tripitakaContents1,
                  AppStrings.tripitakaContents2,
                  AppStrings.tripitakaContents3,
                ],
              ),
              _ClassicCardData(
                type: ClassicType.iching,
                title: AppStrings.ichingName,
                description: AppStrings.ichingDesc,
                contentsSubtitle: AppStrings.ichingContentsSubtitle,
                contents: [
                  AppStrings.ichingContents1,
                  AppStrings.ichingContents2,
                ],
              ),
            ],
            height: height,
            initialPage: initialPage,
            showIndicator: false,
            isScrollable: !isLoading,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, data, isActive) => ClassicCard(
              type: data.type,
              title: data.title,
              description: data.description,
              contentsSubtitle: data.contentsSubtitle,
              contents: data.contents,
            ),
          ),
        )
            .gudaFadeSlideIn(duration: const Duration(milliseconds: 400), begin: const Offset(0, 0.05)),
        const SizedBox(height: GudaSpacing.xl),
        ValueListenableBuilder<bool>(
          valueListenable: _isLoading,
          builder: (context, isLoading, _) => ClassicStartButton(
            onPressed: _handleStart,
            isLoading: isLoading,
          ),
        )
            .gudaFadeIn(delay: GudaDuration.fast)
            .gudaScaleIn(
              duration: GudaDuration.normal,
              curve: Curves.easeOutBack,
            ),
      ],
    );
  }
}

class _ClassicCardData {
  const _ClassicCardData({
    required this.type,
    required this.title,
    required this.description,
    required this.contentsSubtitle,
    required this.contents,
  });

  final ClassicType type;
  final String title;
  final String description;
  final String contentsSubtitle;
  final List<String> contents;
}
