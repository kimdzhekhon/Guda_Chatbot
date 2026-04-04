import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_page_slider.dart';
import 'package:guda_chatbot/features/payment/domain/entities/payment_plan.dart';
import 'package:guda_chatbot/features/payment/presentation/widgets/payment_plan_card.dart';

class PaymentPlanSlider extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final responsiveHeight = (screenHeight * 0.45).clamp(300.0, 480.0);

    return GudaPageSlider<PaymentPlan>(
      items: plans,
      height: responsiveHeight,
      enableScale: true,
      itemBuilder: (context, plan, isActive) {
        return PaymentPlanCard(
          plan: plan,
          isSelected: isActive,
          isCurrentPlan: currentProductId == plan.id,
          remainingCount: currentProductId == plan.id ? remainingCount : null,
          totalLimit: currentProductId == plan.id ? totalLimit : null,
          onTap: () => onPlanSelected(plan),
        );
      },
    );
  }
}
