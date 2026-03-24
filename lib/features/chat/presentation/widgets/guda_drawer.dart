import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guda_chatbot/app/router/route_paths.dart';
import 'package:guda_chatbot/core/utils/date_extensions.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_error_widget.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_loading_widget.dart';
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
            ? GudaColors.backgroundDark
            : GudaColors.backgroundLight,
        child: Column(
          children: [
            const GudaDrawerHeader(),
            Expanded(
              child: switch (state) {
                UiLoading() => const GudaLoadingWidget(message: '목록 로딩 중...'),
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
            const GudaDrawerFooter(),
          ],
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
      padding: const EdgeInsets.only(
        top: GudaSpacing.xxl,
        bottom: GudaSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isDark ? GudaColors.surfaceDark : GudaColors.surfaceLight,
        border: Border(
          bottom: BorderSide(
            color: (isDark ? GudaColors.dividerDark : GudaColors.dividerLight)
                .withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/app_logo_transparent.png',
            width: 28,
            height: 28,
          ),
          const SizedBox(height: GudaSpacing.sm),
          Text(
            '대화 기록',
            style: GudaTypography.heading3(
              color: isDark
                  ? GudaColors.onSurfaceDark
                  : GudaColors.onSurfaceLight,
            ).copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class GudaDrawerList extends ConsumerWidget {
  const GudaDrawerList({super.key, required this.conversations});

  final List<Conversation> conversations;

  String _typeIcon(ClassicType type) => switch (type) {
    ClassicType.tripitaka => 'assets/images/Tripitakakoreana.png',
    ClassicType.iching => 'assets/images/I Ching.png',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (conversations.isEmpty) {
      return Center(
        child: Text(
          '아직 대화가 없습니다',
          style: GudaTypography.body2(
            color: isDark
                ? GudaColors.onSurfaceVariantDark
                : GudaColors.onSurfaceVariantLight,
          ),
        ),
      );
    }

    final sorted = [...conversations]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: GudaSpacing.sm),
      itemCount: sorted.length,
      separatorBuilder: (_, index) => Divider(
        height: 1,
        indent: GudaSpacing.md,
        color: isDark
            ? GudaColors.dividerDark.withValues(alpha: 0.3)
            : GudaColors.dividerLight.withValues(alpha: 0.5),
      ),
      itemBuilder: (context, index) {
        final conv = sorted[index];
        final isActive =
            ref.watch(homeViewModelProvider).activeConversationId == conv.id;

        return ListTile(
          onTap: () {
            ref.read(homeViewModelProvider.notifier).selectConversation(conv);
            Navigator.pop(context);
          },
          selected: isActive,
          selectedTileColor:
              (isDark ? GudaColors.primary : GudaColors.surfaceVariantLight)
                  .withValues(alpha: 0.1),
          leading: ClipRRect(
            borderRadius: GudaRadius.smAll,
            child: Image.asset(
              _typeIcon(conv.classicType),
              width: 28,
              height: 28,
              fit: BoxFit.cover,
            ),
          ),
          horizontalTitleGap: GudaSpacing.md,
          title: Text(
            conv.title,
            style: GudaTypography.body2(
              color: isDark
                  ? GudaColors.onSurfaceDark
                  : GudaColors.onSurfaceLight,
            ).copyWith(
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
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
      padding: EdgeInsets.only(
        left: GudaSpacing.md,
        right: GudaSpacing.md,
        top: GudaSpacing.md,
        bottom: MediaQuery.of(context).padding.bottom + GudaSpacing.md,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: (isDark ? GudaColors.dividerDark : GudaColors.dividerLight)
                .withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
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
              label: const Text('새 채팅'),
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
    );
  }
}
