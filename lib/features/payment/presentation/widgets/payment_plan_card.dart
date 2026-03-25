import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_divider.dart';
import 'package:guda_chatbot/features/payment/domain/entities/payment_plan.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_card.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_button.dart';

class PaymentPlanCard extends StatelessWidget {
  final PaymentPlan plan;
  final bool isSelected;
  final VoidCallback? onTap;

  const PaymentPlanCard({
    super.key,
    required this.plan,
    this.isSelected = false,
    this.onTap,
  });

  String _formatNumber(num number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GudaCard(
      margin: const EdgeInsets.symmetric(horizontal: GudaSpacing.sm),
      padding: EdgeInsets.zero,
      showBorder: true,
      backgroundColor: isDark ? GudaColors.surfaceDark : GudaColors.surfaceLight,
      borderRadius: GudaRadius.lgAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: GudaRadius.lgAll,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: GudaRadius.lgAll,
            border: isSelected 
                ? Border.all(color: GudaColors.accent, width: 2)
                : null,
          ),
          padding: const EdgeInsets.all(GudaSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                plan.name,
                style: GudaTypography.heading3(
                  color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: GudaSpacing.sm),
              Text(
                plan.description,
                textAlign: TextAlign.center,
                style: GudaTypography.caption(
                  color: isDark ? GudaColors.onSurfaceVariantDark : GudaColors.onSurfaceVariantLight,
                ),
              ),
              const Spacer(),
              const GudaDivider(height: GudaSpacing.xl),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    _formatNumber(plan.price),
                    style: GudaTypography.heading1(
                      color: GudaColors.accent,
                    ).copyWith(fontSize: 36, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '원',
                    style: GudaTypography.body1(
                      color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: GudaSpacing.xs),
              Text(
                plan.type == PaymentType.subscription 
                  ? '월 ${plan.chatLimit}회 제공' 
                  : '${plan.chatLimit}회 충전',
                style: GudaTypography.body2Bold(
                  color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '회당 약 ${_formatNumber(plan.pricePerChat)}원',
                style: GudaTypography.caption(
                  color: isDark ? GudaColors.onSurfaceVariantDark : GudaColors.onSurfaceVariantLight,
                ).copyWith(fontSize: 13),
              ),
              const Spacer(),
              GudaButton.filled(
                label: '선택하기',
                onPressed: onTap ?? () {},
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
