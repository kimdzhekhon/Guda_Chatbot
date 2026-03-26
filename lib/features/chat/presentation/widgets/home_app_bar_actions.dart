import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guda_chatbot/app/router/route_paths.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_usage_viewmodel.dart';
import 'package:guda_chatbot/features/payment/presentation/widgets/payment_selection_modal.dart';

class HomeAppBarActions extends ConsumerWidget {
  const HomeAppBarActions({
    super.key,
    required this.activeId,
    required this.hideChatCount,
  });

  final String? activeId;
  final bool hideChatCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usage = ref.watch(chatUsageViewModelProvider);

    return Row(
      children: [
        if (activeId != null && !hideChatCount)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                right: GudaSpacing.md,
                top: 6,
              ),
              child: Text(
                '${AppStrings.remainingChatCount}${usage.remainingCount}${AppStrings.countUnit}',
                style: GudaTypography.caption(
                  color: context.onSurfaceVariantColor,
                ).copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        if (activeId == null) ...[
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => _showPaymentModal(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(RoutePaths.settings),
          ),
        ],
      ],
    );
  }

  void _showPaymentModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PaymentSelectionModal(),
    );
  }
}
