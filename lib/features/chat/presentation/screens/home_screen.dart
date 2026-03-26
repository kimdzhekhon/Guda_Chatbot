import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_scaffold.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_viewmodels.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/home_viewmodel.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/guda_drawer.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/classic_card_slider.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/guda_home_app_bar.dart';

import 'package:guda_chatbot/features/chat/presentation/widgets/chat_room_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final activeId = homeState.activeConversationId;

    final isMessagesEmpty = activeId != null
        ? ref.watch(chatRoomViewModelProvider(activeId).select(
            (state) => state.dataOrNull?.isEmpty ?? true,
          ))
        : true;

    final showBackButton = activeId != null && isMessagesEmpty;
    final hideChatCount = activeId != null &&
        isMessagesEmpty &&
        homeState.selectedClassicType != ClassicType.tripitaka &&
        homeState.phase != CardPhase.input;

    return GudaScaffold(
      useSafeArea: false,
      appBar: GudaHomeAppBar(
        showBackButton: showBackButton,
        activeId: activeId,
        hideChatCount: hideChatCount,
      ),
      drawer: const GudaDrawer(),
      body: activeId == null
          ? const Center(
              child: SingleChildScrollView(child: ClassicCardSlider()),
            )
          : ChatRoomView(activeConversationId: activeId),
    );
  }
}
