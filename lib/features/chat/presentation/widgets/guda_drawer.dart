import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_lottie.dart';
import 'package:guda_chatbot/app/router/route_paths.dart';
import 'package:guda_chatbot/core/constants/app_assets.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/utils/date_extensions.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_error_widget.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_loading_widget.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_brand_header.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_tile.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_divider.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/domain/entities/conversation.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_viewmodels.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/home_viewmodel.dart';

class GudaDrawer extends ConsumerWidget {
  const GudaDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatListViewModelProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Drawer(
        backgroundColor: isDark
            ? GudaColors.surfaceDark
            : GudaColors.surfaceLight,
        child: SafeArea(
          child: Column(
            children: [
              const GudaDrawerHeader(),
              Expanded(
                child: switch (state) {
                  UiLoading() => GudaLoadingWidget(message: AppStrings.loadingChatList),
                  UiError(message: final msg) => GudaErrorWidget(
                    message: msg,
                    onRetry: () =>
                        ref.read(chatListViewModelProvider.notifier).refresh(),
                  ),
                  UiSuccess(data: final conversations) => GudaDrawerList(
                    conversations: conversations,
                  ),
                },
              ),
              if (ref.watch(homeViewModelProvider).activeConversationId != null)
                const GudaDrawerFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class GudaDrawerHeader extends StatelessWidget {
  const GudaDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: GudaSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isDark ? GudaColors.surfaceDark : GudaColors.surfaceLight,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GudaBrandHeader(
            isLarge: false,
            showLogo: false,
            title: AppStrings.historyHeader,
            color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
          ),
          const SizedBox(height: GudaSpacing.md),
        ],
      ),
    );
  }
}

class GudaDrawerList extends ConsumerWidget {
  const GudaDrawerList({super.key, required this.conversations});

  final List<Conversation> conversations;

  String _typeIcon(ClassicType type) => switch (type) {
    ClassicType.tripitaka => AppAssets.tripitakaImage,
    ClassicType.iching => AppAssets.ichingImage,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GudaLottie(
              path: AppAssets.lotusLottie,
              size: 160,
            ),
            const SizedBox(height: GudaSpacing.md),
            Text(
              AppStrings.noConversations,
              style: GudaTypography.body2(
                color: isDark
                    ? GudaColors.onSurfaceVariantDark
                    : GudaColors.onSurfaceVariantLight,
              ),
            ),
          ],
        ),
      );
    }

    final sorted = [...conversations]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: GudaSpacing.sm),
      itemCount: sorted.length,
      separatorBuilder: (_, index) => const GudaDivider(
        indent: GudaSpacing.md,
        alpha: 0.3,
      ),
      itemBuilder: (context, index) {
        final conv = sorted[index];
        final isActive =
            ref.watch(homeViewModelProvider).activeConversationId == conv.id;

        return GudaTile(
          onTap: () {
            ref.read(homeViewModelProvider.notifier).selectConversation(conv);
            Navigator.pop(context);
          },
          selected: isActive,
          leading: ClipRRect(
            borderRadius: GudaRadius.smAll,
            child: Image.asset(
              _typeIcon(conv.classicType),
              width: 28,
              height: 28,
              fit: BoxFit.cover,
            ),
          ),
          title: conv.title,
          subtitle: Text(
            conv.updatedAt.toLocal().toMmDd(),
            style: GudaTypography.caption(
              color: (isDark
                      ? GudaColors.onSurfaceVariantDark
                      : GudaColors.onSurfaceVariantLight)
                  .withValues(alpha: 0.6),
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline_rounded, size: 16),
            onPressed: () => ref
                .read(chatListViewModelProvider.notifier)
                .deleteConversation(conv.id),
            color: (isDark
                    ? GudaColors.onSurfaceVariantDark
                    : GudaColors.onSurfaceVariantLight)
                .withValues(alpha: 0.4),
          ),
        );
      },
    );
  }
}

class GudaDrawerFooter extends ConsumerWidget {
  const GudaDrawerFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(GudaSpacing.md),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.transparent, // Handled by GudaDivider inside
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const GudaDivider(height: 1),
          const SizedBox(height: GudaSpacing.md),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.push(RoutePaths.settings);
                },
                icon: const Icon(Icons.settings_outlined),
                padding: const EdgeInsets.all(GudaSpacing.md),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: isDark
                      ? GudaColors.onSurfaceVariantDark
                      : GudaColors.onSurfaceVariantLight,
                  shape: RoundedRectangleBorder(borderRadius: GudaRadius.mdAll),
                ),
              ),
              const SizedBox(width: GudaSpacing.md),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref
                        .read(homeViewModelProvider.notifier)
                        .clearActiveConversation();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text(AppStrings.newChat),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark
                        ? GudaColors.onSurfaceDark
                        : GudaColors.onSurfaceLight,
                    side: BorderSide(
                      color: (isDark
                              ? GudaColors.dividerDark
                              : GudaColors.dividerLight)
                          .withValues(alpha: 0.8),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: GudaRadius.mdAll),
                    padding: const EdgeInsets.symmetric(vertical: GudaSpacing.md),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
