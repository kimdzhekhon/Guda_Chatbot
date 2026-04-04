import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/tokens/animation_tokens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_error_widget.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_loading_widget.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_viewmodels.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/home_viewmodel.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/message_list.dart';

class ChatRoomView extends ConsumerStatefulWidget {
  const ChatRoomView({
    super.key,
    required this.activeChatRoomId,
  });

  final String activeChatRoomId;

  @override
  ConsumerState<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends ConsumerState<ChatRoomView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: GudaDuration.normal,
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedType = ref.watch(
      homeViewModelProvider.select((s) => s.selectedClassicType),
    );
    final chatState = ref.watch(chatRoomViewModelProvider(widget.activeChatRoomId));

    // Listen for new messages to scroll to bottom
    ref.listen(chatRoomViewModelProvider(widget.activeChatRoomId), (_, next) {
      if (next.isSuccess) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });

    final isStreaming = ref.watch(
      chatRoomViewModelProvider(widget.activeChatRoomId).select(
        (s) => s.dataOrNull?.any((m) => m.isStreaming) ?? false,
      ),
    );
    final messages = chatState.dataOrNull ?? [];
    final showInput = messages.isNotEmpty || selectedType == ClassicType.tripitaka;

    return Column(
      children: [
        Expanded(
          child: switch (chatState) {
            UiLoading() => const GudaLoadingWidget(message: AppStrings.processing),
            UiError(message: final msg) => GudaErrorWidget(message: msg),
        UiSuccess(data: final messages) => MessageList(
                messages: messages,
                type: selectedType,
                scrollController: _scrollController,
                onSendMessage: _handleSendMessage,
                activeChatRoomId: widget.activeChatRoomId,
              ),
          },
        ),
        if (showInput)
          ChatInputBar(
            isLoading: isStreaming,
            onSend: _handleSendMessage,
            maxLength: selectedType == ClassicType.iching ? 100 : 500,
          ),
      ],
    );
  }

  Future<void> _handleSendMessage(String text) async {
    final homeState = ref.read(homeViewModelProvider);
    await ref
        .read(chatRoomViewModelProvider(widget.activeChatRoomId).notifier)
        .sendMessage(
          content: text,
          topicCode: homeState.selectedClassicType,
          hexagramId: homeState.selectedHexagram?.id.toString(),
        );
  }
}
