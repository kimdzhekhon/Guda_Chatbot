import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/features/payment/domain/entities/payment_plan.dart';
import 'package:guda_chatbot/features/payment/presentation/viewmodels/payment_viewmodel.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_bottom_sheet.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_bottom_sheet_header.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_toggle_control.dart';

import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

import 'package:guda_chatbot/features/payment/presentation/widgets/payment_plan_slider.dart';

class PaymentSelectionModal extends ConsumerWidget {
  const PaymentSelectionModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(paymentViewModelProvider.select((s) => s.currentPlans));
    final selectedType = ref.watch(paymentViewModelProvider.select((s) => s.selectedType));

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
              color: context.onSurfaceVariantColor,
            ),
          ),
          const SizedBox(height: GudaSpacing.lg),
          GudaToggleControl<PaymentType>(
            selectedValue: selectedType,
            options: const [
              GudaToggleOption(
                  label: AppStrings.subscriptionTypeLabel,
                  value: PaymentType.subscription),
              GudaToggleOption(
                  label: AppStrings.chargeTypeLabel, value: PaymentType.charge),
            ],
            onChanged: (type) {
              if (selectedType != type) {
                ref.read(paymentViewModelProvider.notifier).selectType(type);
              }
            },
          ),
          const SizedBox(height: GudaSpacing.lg),
          PaymentPlanSlider(
            key: ValueKey(selectedType),
            plans: plans,
            onPlanSelected: (plan) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        '${plan.name} ${AppStrings.planSelectionSuffix}')),
              );
            },
          ),
        ],
      ),
    );
  }
}
