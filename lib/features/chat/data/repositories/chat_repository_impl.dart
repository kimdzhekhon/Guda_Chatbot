import 'package:guda_chatbot/features/chat/data/datasources/supabase_chat_datasource.dart';
import 'package:guda_chatbot/features/chat/domain/entities/conversation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/message.dart';
import 'package:guda_chatbot/features/chat/domain/repositories/chat_repository.dart';

/// ChatRepository 구현체 — data 레이어
class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this._dataSource);
  final SupabaseChatDataSource _dataSource;

  @override
  Future<List<Conversation>> getConversations() =>
      _dataSource.getConversations();

  @override
  Future<List<Message>> getMessages(String conversationId) =>
      _dataSource.getMessages(conversationId);

  @override
  Future<Conversation> createConversation({
    required String title,
    required String classicType,
  }) => _dataSource.createConversation(title: title, classicType: classicType);

  @override
  Future<void> deleteConversation(String conversationId) =>
      _dataSource.deleteConversation(conversationId);

  @override
  Future<Message> saveMessage({
    required String conversationId,
    required String content,
    required String role,
  }) => _dataSource.saveMessage(
    conversationId: conversationId,
    content: content,
    role: role,
  );

  @override
  Stream<String> streamResponse({
    required String conversationId,
    required String userMessage,
    required String classicType,
  }) => _dataSource.streamResponse(
    conversationId: conversationId,
    userMessage: userMessage,
    classicType: classicType,
  );
}
