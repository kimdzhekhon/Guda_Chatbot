import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:guda_chatbot/app/router/route_paths.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_error_widget.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_loading_widget.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/domain/entities/message.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_viewmodels.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/home_viewmodel.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/guda_drawer.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/message_bubble.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/classic_card_slider.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/initial_question_card.dart';

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
      appBar: AppBar(
        title: Text(
          AppStrings.appName,
          style: GudaTypography.heading2(
            color: isDark
                ? GudaColors.onSurfaceDark
                : GudaColors.onSurfaceLight,
          ).copyWith(fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(showBackButton ? Icons.arrow_back : Icons.menu),
            onPressed: () {
              if (showBackButton) {
                ref
                    .read(homeViewModelProvider.notifier)
                    .clearActiveConversation();
              } else {
                Scaffold.of(context).openDrawer();
              }
            },
          ),
        ),
        actions: [
          if (activeId == null)
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                context.push(RoutePaths.settings);
              },
            ),
        ],
      ),
      drawer: const GudaDrawer(),
      body: activeId == null
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
                final chatState =
                    ref.watch(chatRoomViewModelProvider(activeId));
                final isStreaming =
                    chatState.dataOrNull?.any((m) => m.isStreaming) ?? false;
                final messages = chatState.dataOrNull ?? [];

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
                        UiSuccess(data: final messages) => _buildMessageList(
                          messages,
                          isDark,
                          homeState.selectedClassicType,
                        ),
                      },
                    ),
                    if (messages.isNotEmpty ||
                        homeState.selectedClassicType == ClassicType.tripitaka)
                      ChatInputBar(
                        isLoading: isStreaming,
                        onSend: (text) => _handleSendMessage(text, homeState),
                      ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildMessageList(
    List<Message> messages,
    bool isDark,
    ClassicType type,
  ) {
    if (messages.isEmpty) {
      if (type == ClassicType.tripitaka) {
        final activeId =
            ref.read(homeViewModelProvider).activeConversationId ?? '';
        // 팔만대장경은 채팅 형식으로 시작
        return ListView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: GudaSpacing.sm),
          children: [
            MessageBubble(
              message: Message(
                id: 'tripitaka-guidance',
                conversationId: activeId,
                content: type.guidanceMessage,
                role: MessageRole.assistant,
                createdAt: DateTime.now(),
              ),
              isDark: isDark,
            ),
          ],
        );
      }

      return Center(
            child: SingleChildScrollView(
              child: InitialQuestionCard(
                type: type,
                onSkip: () =>
                    _handleSendMessage('', ref.read(homeViewModelProvider)),
                onStart: (question) => _handleSendMessage(
                  question,
                  ref.read(homeViewModelProvider),
                ),
              ),
            ),
          )
          .animate()
          .fadeIn(duration: 600.ms)
          .scale(begin: const Offset(0.95, 0.95));
    }
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: GudaSpacing.sm),
      itemCount: messages.length,
      itemBuilder: (context, index) =>
          MessageBubble(message: messages[index], isDark: isDark),
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
