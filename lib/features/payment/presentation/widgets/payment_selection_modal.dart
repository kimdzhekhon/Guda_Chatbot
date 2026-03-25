import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/features/payment/domain/entities/payment_plan.dart';
import 'package:guda_chatbot/features/payment/presentation/viewmodels/payment_viewmodel.dart';
import 'package:guda_chatbot/features/payment/presentation/widgets/payment_plan_card.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_bottom_sheet.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_bottom_sheet_header.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_toggle_control.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_page_indicator.dart';

class PaymentSelectionModal extends ConsumerStatefulWidget {
  const PaymentSelectionModal({super.key});

  @override
  ConsumerState<PaymentSelectionModal> createState() => _PaymentSelectionModalState();
}

class _PaymentSelectionModalState extends ConsumerState<PaymentSelectionModal> {
  final PageController _pageController = PageController(viewportFraction: 0.85, initialPage: 0);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _resetPage() {
    setState(() {
      _currentPage = 0;
    });
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

    return GudaBottomSheet(
      heightFactor: 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GudaBottomSheetHeader(
            title: AppStrings.membershipChargeTitle,
            onClose: () => Navigator.pop(context),
          ),
          const SizedBox(height: GudaSpacing.xs),
          Text(
            AppStrings.membershipChargeDesc,
            style: GudaTypography.caption(
              color: isDark ? GudaColors.onSurfaceVariantDark : GudaColors.onSurfaceVariantLight,
            ),
          ),
          const SizedBox(height: GudaSpacing.lg),
          
          GudaToggleControl<PaymentType>(
            isDark: isDark,
            selectedValue: paymentState.selectedType,
            options: const [
              GudaToggleOption(label: AppStrings.subscriptionTypeLabel, value: PaymentType.subscription),
              GudaToggleOption(label: AppStrings.chargeTypeLabel, value: PaymentType.charge),
            ],
            onChanged: (type) {
              if (paymentState.selectedType != type) {
                ref.read(paymentViewModelProvider.notifier).selectType(type);
                _resetPage();
              }
            },
          ),
          
          const SizedBox(height: GudaSpacing.lg),
          SizedBox(
            height: 420,
            child: PageView.builder(
              key: ValueKey(paymentState.selectedType),
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
                        SnackBar(content: Text('${plan.name} ${AppStrings.planSelectionSuffix}')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: GudaSpacing.lg),
          GudaPageIndicator(
            count: plans.length,
            currentIndex: _currentPage,
          ),
        ],
      ),
    );
  }
}
