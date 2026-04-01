import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/features/chat/data/datasources/supabase_chat_datasource.dart';
import 'package:guda_chatbot/core/network/rpc_invoker.dart';
import 'package:guda_chatbot/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/domain/entities/conversation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/message.dart';
import 'package:guda_chatbot/features/chat/domain/repositories/chat_repository.dart';
import 'package:guda_chatbot/features/chat/domain/usecases/create_conversation_usecase.dart';
import 'package:guda_chatbot/features/chat/domain/usecases/delete_conversation_usecase.dart';
import 'package:guda_chatbot/features/chat/domain/usecases/get_conversations_usecase.dart';
import 'package:guda_chatbot/features/chat/domain/usecases/get_messages_usecase.dart';
import 'package:guda_chatbot/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_usage_viewmodel.dart';
import 'package:guda_chatbot/features/settings/presentation/viewmodels/persona_viewmodel.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';

part 'chat_viewmodels.g.dart';

// ── Provider 의존성 (DI) ──────────────────────────────

@riverpod
RpcInvoker rpcInvoker(Ref ref) => SupabaseRpcInvoker();

@riverpod
SupabaseChatDataSource supabaseChatDataSource(Ref ref) =>
    SupabaseChatDataSource(ref.watch(rpcInvokerProvider));

@riverpod
ChatRepository chatRepository(Ref ref) =>
    ChatRepositoryImpl(ref.watch(supabaseChatDataSourceProvider));

@riverpod
GetConversationsUseCase getConversationsUseCase(Ref ref) =>
    GetConversationsUseCase(ref.watch(chatRepositoryProvider));

@riverpod
CreateConversationUseCase createConversationUseCase(Ref ref) =>
    CreateConversationUseCase(ref.watch(chatRepositoryProvider));

@riverpod
DeleteConversationUseCase deleteConversationUseCase(Ref ref) =>
    DeleteConversationUseCase(ref.watch(chatRepositoryProvider));

@riverpod
GetMessagesUseCase getMessagesUseCase(Ref ref) =>
    GetMessagesUseCase(ref.watch(chatRepositoryProvider));

@riverpod
SendMessageUseCase sendMessageUseCase(Ref ref) =>
    SendMessageUseCase(ref.watch(chatRepositoryProvider));

// ── Chat List ViewModel ────────────────────────────

@riverpod
class ChatListViewModel extends _$ChatListViewModel {
  @override
  UiState<List<Conversation>> build() {
    // 초기 로딩 수행
    Future.microtask(() => refresh());
    return const UiLoading();
  }

  Future<void> refresh() async {
    if (!ref.mounted) return;
    state = const UiLoading();
    try {
      final useCase = ref.read(getConversationsUseCaseProvider);
      final conversations = await useCase();
      if (!ref.mounted) return;
      state = UiSuccess(conversations);
    } catch (e) {
      if (!ref.mounted) return;
      state = UiError('${AppStrings.conversationLoadFail}: ${e.toString()}');
    }
  }

  Future<Conversation?> createConversation({
    required ClassicType topicCode,
    required String personaId,
  }) async {
    try {
      final useCase = ref.read(createConversationUseCaseProvider);
      final newConv = await useCase(
        title: '${topicCode.displayName} 새 대화',
        topicCode: topicCode.name,
        personaId: personaId,
      );
      
      // 목록 갱신
      await refresh();
      return newConv;
    } catch (e) {
      state = UiError('${AppStrings.conversationCreateFail}: ${e.toString()}');
      return null;
    }
  }

  Future<void> deleteConversation(String chatRoomId) async {
    try {
      final useCase = ref.read(deleteConversationUseCaseProvider);
      await useCase(chatRoomId);
      await refresh();
    } catch (e) {
      state = UiError('${AppStrings.conversationDeleteFail}: ${e.toString()}');
    }
  }
}

// ── Sorted Conversations Provider (Optimization) ──────────────────

@riverpod
List<Conversation> sortedConversations(Ref ref) {
  final chatListState = ref.watch(chatListViewModelProvider);
  final data = chatListState.dataOrNull ?? [];
  return [...data]..sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
}

// ── Chat Room ViewModel ────────────────────────────

@riverpod
class ChatRoomViewModel extends _$ChatRoomViewModel {
  bool _isSending = false;

  @override
  UiState<List<Message>> build(String chatRoomId) {
    Future.microtask(() => _loadMessages());
    return const UiLoading();
  }

  Future<void> _loadMessages() async {
    // sendMessage 진행 중이면 낙관적 상태를 보호하기 위해 스킵
    if (_isSending) return;

    // 이미 로딩이 불필요한 상황(예: sendMessage로 인해 성공 상태 진입)이면 state 변경을 최소화
    if (state is! UiSuccess) {
      if (!ref.mounted) return;
      state = const UiLoading();
    }
    try {
      final useCase = ref.read(getMessagesUseCaseProvider);
      final dbMessages = await useCase(chatRoomId);
      if (!ref.mounted) return;

      // sendMessage가 도중에 시작되었으면 DB 결과로 덮어쓰지 않음
      if (_isSending) return;

      // 만약 가져오는 도중 sendMessage가 호출되어 State에 임시 메시지가 존재한다면 병합
      final currentData = state.dataOrNull;
      if (currentData != null && currentData.any((m) => m.isStreaming || m.id > 1000000000000)) {
        final tempMsgs = currentData.where((m) => m.isStreaming || m.id > 1000000000000).toList();
        state = UiSuccess([...dbMessages, ...tempMsgs]);
      } else {
        state = UiSuccess(dbMessages);
      }
    } catch (e) {
      if (!ref.mounted) return;
      state = UiError('${AppStrings.messageLoadFail} ${e.toString()}');
    }
  }

  Future<void> sendMessage({
    required String content,
    required ClassicType topicCode,
  }) async {
    // autoDispose 방지: 위젯 전환(PendingChatRoomView → ChatRoomView) 동안
    // watcher가 없어도 provider가 폐기되지 않도록 유지
    final keepAliveLink = ref.keepAlive();
    _isSending = true;

    final currentMessages = state.dataOrNull ?? [];

    // 대화 크레딧 차감 (DB 반영)
    final hasCredit = await ref.read(chatUsageViewModelProvider.notifier).useChatCredit();
    if (!hasCredit) {
      if (!ref.mounted) return;
      state = UiSuccess([
        ...currentMessages,
        Message(
          id: DateTime.now().millisecondsSinceEpoch,
          chatRoomId: chatRoomId,
          senderRole: MessageRole.assistant,
          content: '남은 대화 횟수가 없습니다. 추가 대화권을 구매해 주세요.',
          createdAt: DateTime.now(),
        ),
      ]);
      return;
    }

    // 1. 임시 사용자 메시지 추가 (반응성)
    final tempUserMsg = Message(
      id: DateTime.now().millisecondsSinceEpoch,
      chatRoomId: chatRoomId,
      senderRole: MessageRole.user,
      content: content,
      createdAt: DateTime.now(),
    );

    // AI 스트리밍용 빈 메시지 추가
    final aiStreamingMsg = Message(
      id: DateTime.now().millisecondsSinceEpoch + 1,
      chatRoomId: chatRoomId,
      senderRole: MessageRole.assistant,
      content: '',
      createdAt: DateTime.now(),
      isStreaming: true,
    );

    try {
      if (!ref.mounted) return;
      state = UiSuccess([...currentMessages, tempUserMsg, aiStreamingMsg]);

      final useCase = ref.read(sendMessageUseCaseProvider);
      final personaId = ref.read(personaProvider).dataOrNull;
      String accumulatedContent = '';

      await for (final chunk in useCase(
        chatRoomId: chatRoomId,
        content: content,
        topicCode: topicCode.name,
        personaId: personaId,
      )) {
        if (!ref.mounted) break;
        accumulatedContent += chunk;

        // UI 상태 업데이트
        state = UiSuccess([
          ...currentMessages,
          tempUserMsg,
          aiStreamingMsg.copyWith(content: accumulatedContent),
        ]);
      }

      if (!ref.mounted) return;

      // 스트리밍 종료 후 상태 확정
      state = UiSuccess([
        ...currentMessages,
        tempUserMsg,
        aiStreamingMsg.copyWith(content: accumulatedContent, isStreaming: false),
      ]);

    } catch (e) {
      if (!ref.mounted) return;
      // 에러 발생 시 전체 화면을 에러로 바꾸지 않고, 현재까지의 메시지 상태를 유지
      debugPrint('${AppStrings.messageSendFail} ${e.toString()}');

      state = UiSuccess([
        ...currentMessages,
        tempUserMsg,
        aiStreamingMsg.copyWith(
          content: '죄송합니다. 메시지 전송 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.',
          isStreaming: false,
        ),
      ]);
    } finally {
      _isSending = false;
      keepAliveLink.close();
      // 전송 완료 후 DB에서 실제 메시지를 로드하여 임시 ID를 정식 ID로 교체
      if (ref.mounted) {
        _loadMessages();
      }
    }
  }
}
