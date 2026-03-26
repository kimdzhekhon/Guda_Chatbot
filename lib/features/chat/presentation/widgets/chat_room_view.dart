import 'package:flutter/material.dart';
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
    required this.activeConversationId,
  });

  final String activeConversationId;

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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedType = ref.watch(
      homeViewModelProvider.select((s) => s.selectedClassicType),
    );
    final chatState = ref.watch(chatRoomViewModelProvider(widget.activeConversationId));

    // Listen for new messages to scroll to bottom
    ref.listen(chatRoomViewModelProvider(widget.activeConversationId), (_, next) {
      if (next.isSuccess) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });

    final isStreaming = ref.watch(
      chatRoomViewModelProvider(widget.activeConversationId).select(
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
                activeConversationId: widget.activeConversationId,
              ),
          },
        ),
        if (showInput)
          ChatInputBar(
            isLoading: isStreaming,
            onSend: _handleSendMessage,
          ),
      ],
    );
  }

  Future<void> _handleSendMessage(String text) async {
    final type = ref.read(homeViewModelProvider.select((s) => s.selectedClassicType));
    await ref
        .read(chatRoomViewModelProvider(widget.activeConversationId).notifier)
        .sendMessage(
          content: text,
          classicType: type,
        );
  }
}
