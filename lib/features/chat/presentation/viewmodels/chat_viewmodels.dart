import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/features/chat/data/datasources/supabase_chat_datasource.dart';
import 'package:guda_chatbot/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/domain/entities/conversation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/message.dart';

part 'chat_viewmodels.g.dart';

const _uuid = Uuid();

// ── Provider 의존성 ──────────────────────────────────

@riverpod
SupabaseChatDataSource supabaseChatDataSource(Ref ref) =>
    SupabaseChatDataSource();

@riverpod
ChatRepositoryImpl chatRepository(Ref ref) =>
    ChatRepositoryImpl(ref.watch(supabaseChatDataSourceProvider));

// ── Chat List ViewModel ────────────────────────────

/// 대화 목록 상태 관리
@riverpod
class ChatListViewModel extends _$ChatListViewModel {
  @override
  UiState<List<Conversation>> build() {
    return UiSuccess([
      Conversation(
        id: 'mock-1',
        title: '팔만대장경 첫 대화',
        classicType: ClassicType.tripitaka,
        userId: 'mock-user',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Conversation(
        id: 'mock-2',
        title: '주역의 지혜',
        classicType: ClassicType.iching,
        userId: 'mock-user',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ]);
  }

  Future<void> _loadConversations() async {
    state = const UiLoading();
    try {
      final conversations = await ref
          .read(chatRepositoryProvider)
          .getConversations();
      state = UiSuccess(conversations);
    } catch (e) {
      state = UiError('대화 목록을 불러오는 데 실패했습니다: ${e.toString()}');
    }
  }

  /// 새 대화 생성 (Mock)
  Future<Conversation?> createConversation({
    required ClassicType classicType,
  }) async {
    final conversation = Conversation(
      id: 'mock-${_uuid.v4()}',
      title: '${classicType.displayName} 새 대화',
      classicType: classicType,
      userId: 'mock-user',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    final current = state.dataOrNull ?? [];
    state = UiSuccess([conversation, ...current]);
    return conversation;
  }

  /// 대화 삭제
  Future<void> deleteConversation(String conversationId) async {
    try {
      await ref.read(chatRepositoryProvider).deleteConversation(conversationId);
      await _loadConversations();
    } catch (e) {
      state = UiError('대화 삭제에 실패했습니다: ${e.toString()}');
    }
  }

  /// 새로고침
  Future<void> refresh() => _loadConversations();
}

// ── Chat Room ViewModel ────────────────────────────

/// 특정 대화 세션 상태 관리 — 메시지 목록 + 스트리밍 응답 처리
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
      final messages = await ref
          .read(chatRepositoryProvider)
          .getMessages(conversationId);
      state = UiSuccess(messages);
    } catch (e) {
      state = UiError('메시지를 불러오는 데 실패했습니다: ${e.toString()}');
    }
  }

  /// 메시지 전송 (Mock 스트리밍)
  Future<void> sendMessage({
    required String content,
    required ClassicType classicType,
  }) async {
    final currentMessages = state.dataOrNull ?? [];
    final streamingId = _uuid.v4();

    final userMsg = Message(
      id: _uuid.v4(),
      conversationId: conversationId,
      role: MessageRole.user,
      content: content,
      createdAt: DateTime.now(),
    );

    final streamingMsg = Message(
      id: streamingId,
      conversationId: conversationId,
      role: MessageRole.assistant,
      content: '고전의 지혜를 빌려 답변을 준비 중입니다...',
      createdAt: DateTime.now(),
      isStreaming: true,
    );

    state = UiSuccess([...currentMessages, userMsg, streamingMsg]);

    // Mock 스트리밍 시뮬레이션
    await Future.delayed(const Duration(milliseconds: 500));
    
    String fullResponse = classicType == ClassicType.tripitaka 
      ? "부처님의 말씀에 따르면 모든 것은 마음먹기에 달렸습니다. 마음을 비우고 현재에 집중해 보세요."
      : "주역의 괘를 살펴보니 현재는 나아갈 때가 아닌 머무를 때입니다. 신중하게 행동하십시오.";
    
    state = UiSuccess([...currentMessages, userMsg, streamingMsg.copyWith(content: fullResponse, isStreaming: false)]);
  }
}
