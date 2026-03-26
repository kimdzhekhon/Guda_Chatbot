import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_error_widget.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_loading_widget.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_divider.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_viewmodels.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/home_viewmodel.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/drawer/conversation_history_list.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/drawer/drawer_user_footer.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/drawer/guda_drawer_header.dart';

/// 앱 전체에서 사용되는 히스토리 드로어
class GudaDrawer extends ConsumerWidget {
  const GudaDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatListViewModelProvider);

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Drawer(
        backgroundColor: context.surfaceColor,
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
                  UiSuccess(data: final conversations) => Column(
                    children: [
                      const GudaDivider(),
                      Expanded(
                        child: ConversationHistoryList(
                          conversations: conversations,
                        ),
                      ),
                    ],
                  ),
                },
              ),
              if (ref.watch(homeViewModelProvider).activeConversationId != null)
                const DrawerUserFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

