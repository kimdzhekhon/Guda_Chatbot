import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/features/chat/data/datasources/supabase_chat_datasource.dart';
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
import 'package:guda_chatbot/core/constants/app_strings.dart';

part 'chat_viewmodels.g.dart';

// ── Provider 의존성 (DI) ──────────────────────────────

@riverpod
SupabaseChatDataSource supabaseChatDataSource(Ref ref) =>
    SupabaseChatDataSource();

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
    state = const UiLoading();
    try {
      final useCase = ref.read(getConversationsUseCaseProvider);
      final conversations = await useCase();
      state = UiSuccess(conversations);
    } catch (e) {
      state = UiError('${AppStrings.conversationLoadFail}: ${e.toString()}');
    }
  }

  Future<Conversation?> createConversation({
    required ClassicType classicType,
  }) async {
    try {
      final useCase = ref.read(createConversationUseCaseProvider);
      final newConv = await useCase(
        title: '${classicType.displayName} 새 대화',
        classicType: classicType.name,
      );
      
      // 목록 갱신
      await refresh();
      return newConv;
    } catch (e) {
      state = UiError('${AppStrings.conversationCreateFail}: ${e.toString()}');
      return null;
    }
  }

  Future<void> deleteConversation(String conversationId) async {
    try {
      final useCase = ref.read(deleteConversationUseCaseProvider);
      await useCase(conversationId);
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
  return [...data]..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
}

// ── Chat Room ViewModel ────────────────────────────

@riverpod
class ChatRoomViewModel extends _$ChatRoomViewModel {
  @override
  UiState<List<Message>> build(String conversationId) {
    Future.microtask(() => _loadMessages());
    return const UiLoading();
  }

  Future<void> _loadMessages() async {
    state = const UiLoading();
    try {
      final useCase = ref.read(getMessagesUseCaseProvider);
      final messages = await useCase(conversationId);
      state = UiSuccess(messages);
    } catch (e) {
      state = UiError('${AppStrings.messageLoadFail} ${e.toString()}');
    }
  }

  Future<void> sendMessage({
    required String content,
    required ClassicType classicType,
  }) async {
    final currentMessages = state.dataOrNull ?? [];
    
    // 사용량 증가
    ref.read(chatUsageViewModelProvider.notifier).incrementUsedCount();
    
    // 1. 임시 사용자 메시지 추가 (반응성)
    final tempUserMsg = Message(
      id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      role: MessageRole.user,
      content: content,
      createdAt: DateTime.now(),
    );
    
    // AI 스트리밍용 빈 메시지 추가
    final aiStreamingMsg = Message(
      id: 'ai-streaming',
      conversationId: conversationId,
      role: MessageRole.assistant,
      content: '',
      createdAt: DateTime.now(),
      isStreaming: true,
    );
    
    state = UiSuccess([...currentMessages, tempUserMsg, aiStreamingMsg]);

    try {
      final useCase = ref.read(sendMessageUseCaseProvider);
      String accumulatedContent = '';
      
      await for (final chunk in useCase(
        conversationId: conversationId,
        content: content,
        classicType: classicType.name,
      )) {
        accumulatedContent += chunk;
        
        // UI 상태 업데이트
        state = UiSuccess([
          ...currentMessages,
          tempUserMsg,
          aiStreamingMsg.copyWith(content: accumulatedContent),
        ]);
      }
      
      // 스트리밍 종료 후 상태 확정
      state = UiSuccess([
        ...currentMessages,
        tempUserMsg,
        aiStreamingMsg.copyWith(content: accumulatedContent, isStreaming: false),
      ]);
      
      // DB와 동기화를 위해 실제 메시지 목록 다시 불러오기 (선택 사항)
      // await _loadMessages();
    } catch (e) {
      state = UiError('${AppStrings.messageSendFail} ${e.toString()}');
    }
  }
}
