import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_error_widget.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_loading_widget.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_viewmodels.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/home_viewmodel.dart';
import 'package:guda_chatbot/core/ui/layout/app_responsive_layout.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/guda_drawer.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/classic_card_slider.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/guda_home_app_bar.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/message_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
    final homeState = ref.watch(homeViewModelProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeId = homeState.activeConversationId;

    // 메시지 업데이트 시 스크롤
    if (activeId != null) {
      ref.listen(chatRoomViewModelProvider(activeId), (_, next) {
        if (next.isSuccess) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _scrollToBottom(),
          );
        }
      });
    }

    final isMessagesEmpty = activeId != null
        ? ref.watch(chatRoomViewModelProvider(activeId).select(
            (state) => state.dataOrNull?.isEmpty ?? true,
          ))
        : true;
    final showBackButton = activeId != null && isMessagesEmpty;

    return Scaffold(
      backgroundColor: isDark
          ? GudaColors.backgroundDark
          : GudaColors.backgroundLight,
      appBar: GudaHomeAppBar(
        isDark: isDark,
        showBackButton: showBackButton,
        activeId: activeId,
      ),
      drawer: const GudaDrawer(),
      body: AppResponsiveLayout(
        useSafeArea: false,
        mobile: (context, data) => _buildBody(activeId, homeState, isDark),
      ),
      bottomNavigationBar: activeId == null
          ? null
          : Consumer(
              builder: (context, ref, child) {
                final chatState = ref.watch(chatRoomViewModelProvider(activeId));
                final isStreaming =
                    chatState.dataOrNull?.any((m) => m.isStreaming) ?? false;
                final messages = chatState.dataOrNull ?? [];

                if (messages.isEmpty &&
                    homeState.selectedClassicType != ClassicType.tripitaka) {
                  return const SizedBox.shrink();
                }

                return ChatInputBar(
                  isLoading: isStreaming,
                  onSend: (text) => _handleSendMessage(text, homeState),
                );
              },
            ),
    );
  }

  Widget _buildBody(String? activeId, HomeState homeState, bool isDark) {
    return activeId == null
        ? const Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(child: ClassicCardSlider()),
                ),
              ),
            ],
          )
        : Consumer(
            builder: (context, ref, child) {
              final chatState = ref.watch(chatRoomViewModelProvider(activeId));
              ref.watch(chatRoomViewModelProvider(activeId));

              return Column(
                children: [
                  Expanded(
                    child: switch (chatState) {
                      UiLoading() => const GudaLoadingWidget(
                        message: '불러오는 중...',
                      ),
                      UiError(message: final msg) => GudaErrorWidget(
                        message: msg,
                      ),
                      UiSuccess(data: final messages) => MessageList(
                        messages: messages,
                        isDark: isDark,
                        type: homeState.selectedClassicType,
                        scrollController: _scrollController,
                        onSendMessage: (text) =>
                            _handleSendMessage(text, homeState),
                        activeConversationId: activeId,
                      ),
                    },
                  ),
                ],
              );
            },
          );
  }

  Future<void> _handleSendMessage(String text, HomeState homeState) async {
    String? convId = homeState.activeConversationId;

    // 만약 활성 대화가 없으면 새로 생성
    if (convId == null) {
      final newConv = await ref
          .read(chatListViewModelProvider.notifier)
          .createConversation(classicType: homeState.selectedClassicType);

      if (newConv != null) {
        convId = newConv.id;
        ref.read(homeViewModelProvider.notifier).selectConversation(newConv);
      } else {
        return; // 생성 실패 시 중단
      }
    }

    // 메시지 전송
    await ref
        .read(chatRoomViewModelProvider(convId).notifier)
        .sendMessage(content: text, classicType: homeState.selectedClassicType);
  }
}
