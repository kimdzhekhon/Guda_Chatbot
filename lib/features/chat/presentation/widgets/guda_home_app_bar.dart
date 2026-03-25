import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guda_chatbot/app/router/route_paths.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/home_viewmodel.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_usage_viewmodel.dart';
import 'package:guda_chatbot/features/payment/presentation/widgets/payment_selection_modal.dart';

class GudaHomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const GudaHomeAppBar({
    super.key,
    required this.isDark,
    required this.showBackButton,
    required this.activeId,
    this.hideChatCount = false,
  });

  final bool isDark;
  final bool showBackButton;
  final String? activeId;
  final bool hideChatCount;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usage = ref.watch(chatUsageViewModelProvider);

    return AppBar(
      title: Text(
        AppStrings.appName,
        style: GudaTypography.heading2(
          color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
        ).copyWith(fontWeight: FontWeight.bold, letterSpacing: 2),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(showBackButton ? Icons.arrow_back : Icons.menu),
          onPressed: () {
            if (showBackButton) {
              ref.read(homeViewModelProvider.notifier).clearActiveConversation();
            } else {
              Scaffold.of(context).openDrawer();
            }
          },
        ),
      ),
      actions: [
        if (activeId != null && !hideChatCount)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                right: GudaSpacing.md,
                top: 6, // 바닥선 맞추기 위한 상단 여백 추가
              ),
              child: Text(
                '${AppStrings.remainingChatCount}${usage.remainingCount}${AppStrings.countUnit}',
                style: GudaTypography.caption(
                  color: isDark
                      ? GudaColors.onSurfaceVariantDark
                      : GudaColors.onSurfaceVariantLight,
                ).copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        if (activeId == null)
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const PaymentSelectionModal(),
              );
            },
          ),
        if (activeId == null)
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.push(RoutePaths.settings);
            },
          ),
      ],
    );
  }
}
