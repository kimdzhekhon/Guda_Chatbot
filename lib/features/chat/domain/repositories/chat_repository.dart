import 'package:guda_chatbot/features/chat/domain/entities/conversation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/message.dart';
import 'package:guda_chatbot/features/chat/domain/entities/persona_type.dart';
import 'package:guda_chatbot/features/chat/data/models/chat_request_dtos.dart';

/// Chat 리포지토리 추상 인터페이스
abstract interface class ChatRepository {
  /// 사용자의 모든 대화 목록 조회 (최신순)
  Future<List<Conversation>> getConversations();

  /// 특정 대화의 메시지 목록 조회 (오래된 순)
  Future<List<Message>> getMessages(GetMessagesRequestDto request);

  /// 새 대화 세션 생성
  Future<Conversation> createConversation(CreateConversationRequestDto request);

  /// 대화 삭제
  Future<void> deleteConversation(DeleteConversationRequestDto request);

  /// 사용자 메시지 저장
  Future<Message> saveMessage(SaveMessageRequestDto request);

  /// AI 응답 스트리밍
  Stream<String> streamResponse({
    required String chatRoomId,
    required String userMessage,
    required String topicCode,
    PersonaType? personaId,
  });
}
