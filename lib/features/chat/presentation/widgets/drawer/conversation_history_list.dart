import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/constants/app_assets.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_empty_state.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_divider.dart';
import 'package:guda_chatbot/features/chat/domain/entities/conversation.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_viewmodels.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/home_viewmodel.dart';

import 'package:guda_chatbot/features/chat/presentation/widgets/drawer/conversation_history_item.dart';

class ConversationHistoryList extends ConsumerWidget {
  const ConversationHistoryList({super.key, required this.conversations});

  final List<Conversation> conversations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sorted = ref.watch(sortedConversationsProvider);
    final activeId = ref.watch(homeViewModelProvider.select((s) => s.activeChatRoomId));

    if (sorted.isEmpty) {
      return GudaEmptyState(
        lottiePath: AppAssets.lotusLottie,
        lottieSize: 160,
        title: AppStrings.noConversations,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: GudaSpacing.sm),
      itemCount: sorted.length,
      separatorBuilder: (_, index) => GudaDivider(
        indent: GudaSpacing.md,
        alpha: 0.3,
      ),
      itemBuilder: (context, index) {
        final conv = sorted[index];
        final isActive = activeId == conv.id;

        return ConversationHistoryItem(
          conversation: conv,
          isActive: isActive,
          onTap: () {
            ref.read(homeViewModelProvider.notifier).selectConversation(conv);
            Navigator.pop(context);
          },
          onDelete: () => ref
              .read(chatListViewModelProvider.notifier)
              .deleteConversation(conv.id),
        );
      },
    );
  }
}
