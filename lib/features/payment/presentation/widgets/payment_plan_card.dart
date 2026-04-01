import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_divider.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_price_display.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_progress_bar.dart';
import 'package:guda_chatbot/features/payment/domain/entities/payment_plan.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_card.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_button.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

class PaymentPlanCard extends StatelessWidget {
  final PaymentPlan plan;
  final bool isSelected;
  final bool isCurrentPlan;
  final int? remainingCount;
  final int? totalLimit;
  final VoidCallback? onTap;

  const PaymentPlanCard({
    super.key,
    required this.plan,
    this.isSelected = false,
    this.isCurrentPlan = false,
    this.remainingCount,
    this.totalLimit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GudaCard(
      margin: const EdgeInsets.symmetric(horizontal: GudaSpacing.sm),
      padding: EdgeInsets.zero,
      showBorder: true,
      backgroundColor: context.surfaceColor,
      borderRadius: GudaRadius.lgAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: GudaRadius.lgAll,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: GudaRadius.lgAll,
            border: isSelected 
                ? Border.all(color: context.accentColor, width: 2)
                : null,
          ),
          padding: const EdgeInsets.all(GudaSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isCurrentPlan)
                Container(
                  margin: const EdgeInsets.only(bottom: GudaSpacing.xs),
                  padding: const EdgeInsets.symmetric(
                    horizontal: GudaSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: context.accentColor,
                    borderRadius: GudaRadius.smAll,
                  ),
                  child: Text(
                    '구독 중',
                    style: GudaTypography.captionBold(
                      color: context.colorScheme.onPrimary,
                    ),
                  ),
                ),
              Text(
                plan.name,
                style: GudaTypography.heading3(
                  color: context.onSurfaceColor,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                plan.description,
                textAlign: TextAlign.center,
                style: GudaTypography.caption(
                  color: context.onSurfaceVariantColor,
                ),
              ),
              const Spacer(),
              const SizedBox(height: GudaSpacing.md),
              Container(
                padding: const EdgeInsets.all(GudaSpacing.md),
                decoration: BoxDecoration(
                  color: context.onSurfaceVariantColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  plan.icon,
                  size: 60,
                  color: context.accentColor,
                ),
              ),
              const Spacer(),
              const GudaDivider(height: GudaSpacing.xl),
              const Spacer(),
              GudaPriceDisplay(price: plan.price),
              const SizedBox(height: GudaSpacing.xs),
              Text(
                plan.type == PaymentType.subscription 
                  ? '월 ${plan.chatLimit}회 제공' 
                  : '${plan.chatLimit}회 충전',
                style: GudaTypography.body2Bold(
                  color: context.onSurfaceColor,
                ),
              ),
              const SizedBox(height: GudaSpacing.xs),
              Text(
                '회당 약 ${GudaPriceDisplay.format(plan.pricePerChat)}원',
                style: GudaTypography.caption(
                  color: context.onSurfaceVariantColor,
                ).copyWith(fontSize: 13),
              ),
              const Spacer(),
              if (isCurrentPlan && remainingCount != null && totalLimit != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(GudaSpacing.sm),
                  decoration: BoxDecoration(
                    color: context.accentColor.withValues(alpha: 0.08),
                    borderRadius: GudaRadius.smAll,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '잔여량',
                            style: GudaTypography.caption(
                              color: context.onSurfaceVariantColor,
                            ),
                          ),
                          Text(
                            '$remainingCount / $totalLimit',
                            style: GudaTypography.captionBold(
                              color: context.accentColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: GudaSpacing.xs),
                      GudaProgressBar(
                        value: totalLimit! > 0
                            ? remainingCount! / totalLimit!
                            : 0.0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: GudaSpacing.sm),
              ],
              isCurrentPlan
                  ? GudaButton.outlined(
                      label: '현재 구독 중',
                      onPressed: null,
                      isFullWidth: true,
                    )
                  : GudaButton.filled(
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
