import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_page_indicator.dart';
import 'package:guda_chatbot/features/payment/domain/entities/payment_plan.dart';
import 'package:guda_chatbot/features/payment/presentation/widgets/payment_plan_card.dart';

class PaymentPlanSlider extends StatefulWidget {
  const PaymentPlanSlider({
    super.key,
    required this.plans,
    required this.onPlanSelected,
    this.currentProductId,
    this.remainingCount,
    this.totalLimit,
  });

  final List<PaymentPlan> plans;
  final Function(PaymentPlan) onPlanSelected;
  final String? currentProductId;
  final int? remainingCount;
  final int? totalLimit;

  @override
  State<PaymentPlanSlider> createState() => _PaymentPlanSliderState();
}

class _PaymentPlanSliderState extends State<PaymentPlanSlider> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85, initialPage: 0);
  }

  @override
  void didUpdateWidget(PaymentPlanSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If plans changed (e.g. type changed), reset to first page
    if (oldWidget.plans != widget.plans) {
      _currentPage = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(0);
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 420,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.plans.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final plan = widget.plans[index];
              return AnimatedScale(
                scale: _currentPage == index ? 1.0 : 0.9,
                duration: const Duration(milliseconds: 300),
                child: PaymentPlanCard(
                  plan: plan,
                  isSelected: _currentPage == index,
                  isCurrentPlan: widget.currentProductId == plan.id,
                  remainingCount: widget.currentProductId == plan.id
                      ? widget.remainingCount
                      : null,
                  totalLimit: widget.currentProductId == plan.id
                      ? widget.totalLimit
                      : null,
                  onTap: () => widget.onPlanSelected(plan),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: GudaSpacing.lg),
        GudaPageIndicator(
          count: widget.plans.length,
          currentIndex: _currentPage,
        ),
      ],
    );
  }
}
