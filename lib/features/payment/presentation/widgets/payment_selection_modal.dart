import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/features/payment/domain/entities/payment_plan.dart';
import 'package:guda_chatbot/features/payment/presentation/viewmodels/payment_viewmodel.dart';
import 'package:guda_chatbot/features/payment/presentation/widgets/payment_plan_card.dart';

class PaymentSelectionModal extends ConsumerStatefulWidget {
  const PaymentSelectionModal({super.key});

  @override
  ConsumerState<PaymentSelectionModal> createState() => _PaymentSelectionModalState();
}

class _PaymentSelectionModalState extends ConsumerState<PaymentSelectionModal> {
  final PageController _pageController = PageController(viewportFraction: 0.85, initialPage: 0);
  int _currentPage = 0; // Start with the first item (Guda Light)

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _resetPage() {
    setState(() {
      _currentPage = 0;
    });
    // Use jumpToPage to avoid animation during rebuild if needed, 
    // but PageView builder handles it well.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentViewModelProvider);
    final plans = paymentState.currentPlans;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.only(top: GudaSpacing.xl, bottom: GudaSpacing.xxl),
      decoration: BoxDecoration(
        color: isDark ? GudaColors.backgroundDark : GudaColors.backgroundLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(GudaRadius.lg)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? GudaColors.dividerDark : GudaColors.dividerLight,
              borderRadius: GudaRadius.fullAll,
            ),
          ),
          const SizedBox(height: GudaSpacing.lg),
          Text(
             '구다 멤버십 & 충전',
            style: GudaTypography.heading2(
              color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: GudaSpacing.xs),
          Text(
            '당신에게 가장 잘 맞는 지혜의 여정을 선택하세요',
            style: GudaTypography.caption(
              color: isDark ? GudaColors.onSurfaceVariantDark : GudaColors.onSurfaceVariantLight,
            ),
          ),
          const SizedBox(height: GudaSpacing.lg),
          
          // Category Toggle
          Container(
            padding: const EdgeInsets.all(GudaSpacing.xs),
            decoration: BoxDecoration(
              color: isDark ? GudaColors.surfaceVariantDark : GudaColors.surfaceVariantLight,
              borderRadius: GudaRadius.fullAll,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _CategoryButton(
                  title: '정기 구독형',
                  isSelected: paymentState.selectedType == PaymentType.subscription,
                  onTap: () {
                    if (paymentState.selectedType != PaymentType.subscription) {
                      ref.read(paymentViewModelProvider.notifier).selectType(PaymentType.subscription);
                      _resetPage();
                    }
                  },
                ),
                _CategoryButton(
                  title: '단일 충전형',
                  isSelected: paymentState.selectedType == PaymentType.charge,
                  onTap: () {
                    if (paymentState.selectedType != PaymentType.charge) {
                      ref.read(paymentViewModelProvider.notifier).selectType(PaymentType.charge);
                      _resetPage();
                    }
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: GudaSpacing.lg),
          SizedBox(
            height: 420,
            child: PageView.builder(
              key: ValueKey(paymentState.selectedType), // Ensure new PageView when type changes
              controller: _pageController,
              itemCount: plans.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final plan = plans[index];
                return AnimatedScale(
                  scale: _currentPage == index ? 1.0 : 0.9,
                  duration: const Duration(milliseconds: 300),
                  child: PaymentPlanCard(
                    plan: plan,
                    isSelected: _currentPage == index,
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${plan.name} 선택 완료')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: GudaSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(plans.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index 
                    ? GudaColors.accent 
                    : (isDark ? GudaColors.dividerDark : GudaColors.dividerLight),
                  borderRadius: GudaRadius.fullAll,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.lg, vertical: GudaSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected 
            ? (isDark ? GudaColors.primaryLight : GudaColors.primary) 
            : Colors.transparent,
          borderRadius: GudaRadius.fullAll,
        ),
        child: Text(
          title,
          style: GudaTypography.captionBold(
            color: isSelected 
              ? Colors.white 
              : (isDark ? GudaColors.onSurfaceVariantDark : GudaColors.onSurfaceVariantLight),
          ),
        ),
      ),
    );
  }
}
