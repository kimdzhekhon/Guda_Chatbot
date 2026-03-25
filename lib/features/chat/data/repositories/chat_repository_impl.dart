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
  Future<List<Conversation>> getConversations() async {
    final dtos = await _dataSource.getConversations();
    return dtos.map((dto) => dto.toDomain()).toList();
  }
  @override
  Future<List<Message>> getMessages(GetMessagesRequestDto request) async {
    final dtos = await _dataSource.getMessages(request);
    return dtos.map((dto) => dto.toDomain()).toList();
  }
  @override
  Future<Conversation> createConversation(CreateConversationRequestDto request) async {
    final dto = await _dataSource.createConversation(request);
    return dto.toDomain();
  }
  @override
  Future<void> deleteConversation(DeleteConversationRequestDto request) =>
      _dataSource.deleteConversation(request);
  @override
  Future<Message> saveMessage(SaveMessageRequestDto request) async {
    final dto = await _dataSource.saveMessage(request);
    return dto.toDomain();
  }

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
