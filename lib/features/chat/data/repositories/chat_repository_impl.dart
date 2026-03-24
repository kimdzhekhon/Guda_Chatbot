import 'package:guda_chatbot/features/chat/data/datasources/supabase_chat_datasource.dart';
import 'package:guda_chatbot/features/chat/domain/entities/conversation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/message.dart';
import 'package:guda_chatbot/features/chat/domain/repositories/chat_repository.dart';
import 'package:guda_chatbot/features/chat/data/models/chat_request_dtos.dart';

/// ChatRepository 구현체 — data 레이어
class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this._dataSource);
  final SupabaseChatDataSource _dataSource;

  @override
  Future<List<Conversation>> getConversations() =>
      _dataSource.getConversations();

  @override
  Future<List<Message>> getMessages(GetMessagesRequestDto request) =>
      _dataSource.getMessages(request);

  @override
  Future<Conversation> createConversation(CreateConversationRequestDto request) => 
      _dataSource.createConversation(request);

  @override
  Future<void> deleteConversation(DeleteConversationRequestDto request) =>
      _dataSource.deleteConversation(request);

  @override
  Future<Message> saveMessage(SaveMessageRequestDto request) => 
      _dataSource.saveMessage(request);

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
