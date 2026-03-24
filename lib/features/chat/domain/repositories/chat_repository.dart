import 'package:guda_chatbot/features/chat/domain/entities/conversation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/message.dart';

/// Chat 리포지토리 추상 인터페이스
abstract interface class ChatRepository {
  /// 사용자의 모든 대화 목록 조회 (최신순)
  Future<List<Conversation>> getConversations();

  /// 특정 대화의 메시지 목록 조회 (오래된 순)
  Future<List<Message>> getMessages(String conversationId);

  /// 새 대화 세션 생성
  Future<Conversation> createConversation({
    required String title,
    required String classicType,
  });

  /// 대화 삭제
  Future<void> deleteConversation(String conversationId);

  /// 사용자 메시지 저장
  Future<Message> saveMessage({
    required String conversationId,
    required String content,
    required String role,
  });

  /// Edge Function 스트리밍 호출 — AI 응답을 `Stream<String>`으로 반환
  Stream<String> streamResponse({
    required String conversationId,
    required String userMessage,
    required String classicType,
  });
}
