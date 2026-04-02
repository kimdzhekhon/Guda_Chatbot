import 'package:guda_chatbot/features/chat/data/datasources/supabase_chat_datasource.dart';
import 'package:guda_chatbot/features/chat/domain/entities/chat_usage.dart';
import 'package:guda_chatbot/features/chat/domain/entities/chat_usage_log.dart';
import 'package:guda_chatbot/features/chat/domain/entities/conversation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/message.dart';
import 'package:guda_chatbot/features/chat/domain/entities/save_message_result.dart';
import 'package:guda_chatbot/features/chat/domain/repositories/chat_repository.dart';
import 'package:guda_chatbot/features/chat/domain/entities/persona_type.dart';
import 'package:guda_chatbot/features/chat/data/models/chat_request_dtos.dart';

/// ChatRepository 구현체 — tripitaka 레이어
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
  Future<SaveMessageResult> saveMessage(SaveMessageRequestDto request) =>
      _dataSource.saveMessage(request);

  @override
  Stream<String> streamResponse({
    required String chatRoomId,
    required String userMessage,
    required String topicCode,
    String? hexagramId,
    PersonaType? personaId,
    String? searchContext,
  }) => _dataSource.streamResponse(
    chatRoomId: chatRoomId,
    userMessage: userMessage,
    topicCode: topicCode,
    hexagramId: hexagramId,
    personaId: personaId?.name,
    searchContext: searchContext,
  );

  @override
  Future<ChatUsage> getChatUsage() => _dataSource.getChatUsage();

  @override
  Future<List<ChatUsageLog>> getChatUsageLogs() async {
    final dtos = await _dataSource.getChatUsageLogs();
    return dtos.map((dto) => dto.toDomain()).toList();
  }
}
