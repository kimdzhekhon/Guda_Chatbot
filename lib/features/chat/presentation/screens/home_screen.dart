import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_scaffold.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_viewmodels.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/home_viewmodel.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/guda_drawer.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/classic_card_slider.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/guda_home_app_bar.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/chat_room_view.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/pending_chat_room_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(
      homeViewModelProvider.select((s) => s.activeChatRoomId),
    );
    final isPending = ref.watch(
      homeViewModelProvider.select((s) => s.isPendingNewChat),
    );
    final selectedType = ref.watch(
      homeViewModelProvider.select((s) => s.selectedClassicType),
    );

    final isMessagesEmpty = activeId != null
        ? ref.watch(chatRoomViewModelProvider(activeId).select(
            (state) => state.dataOrNull?.isEmpty ?? true,
          ))
        : true;

    final homeState = ref.read(homeViewModelProvider);
    final showBackButton = homeState.shouldShowBackButton(isMessagesEmpty);
    final hideChatCount = homeState.shouldHideChatCount(isMessagesEmpty);

    Widget body;
    if (isPending) {
      // Pending: DB에 방이 없는 새 대화 상태 → 첫 메시지 입력 대기
      body = PendingChatRoomView(
        topicCode: selectedType,
      );
    } else if (activeId != null) {
      // 기존 대화방 선택 상태
      body = ChatRoomView(activeChatRoomId: activeId);
    } else {
      // 홈 화면 (슬라이더)
      body = const Center(
        child: SingleChildScrollView(child: ClassicCardSlider()),
      );
    }

    return GudaScaffold(
      useSafeArea: false,
      appBar: GudaHomeAppBar(
        showBackButton: showBackButton,
        activeId: activeId,
        hideChatCount: hideChatCount,
      ),
      drawer: const GudaDrawer(),
      body: body,
    );
  }
}
