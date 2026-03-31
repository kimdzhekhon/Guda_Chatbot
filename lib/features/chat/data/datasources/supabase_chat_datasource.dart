import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:guda_chatbot/features/chat/data/models/conversation_dto.dart';
import 'package:guda_chatbot/features/chat/data/models/message_dto.dart';
import 'package:guda_chatbot/features/chat/data/models/chat_request_dtos.dart';
import 'package:guda_chatbot/core/constants/app_personas.dart';
import 'package:guda_chatbot/features/chat/domain/entities/persona_type.dart';

import 'package:guda_chatbot/core/network/rpc_invoker.dart';

/// Supabase 채팅 데이터 소스
class SupabaseChatDataSource {
  SupabaseChatDataSource(this._rpcInvoker) : _supabase = Supabase.instance.client;

  final SupabaseClient _supabase;
  final RpcInvoker _rpcInvoker;

  // ── 대화(Conversation) 관리 ───────────────────────
  
  /// 사용자의 대화 목록 조회
  Future<List<ConversationDto>> getConversations() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    return _rpcInvoker.invokeList(
      functionName: 'get_chat_rooms',
      params: {'p_user_id': userId},
      fromJson: ConversationDto.fromJson,
    );
  }

  /// 특정 대화의 메시지 목록 조회
  Future<List<MessageDto>> getMessages(GetMessagesRequestDto request) async {
    return _rpcInvoker.invokeList(
      functionName: 'get_messages_by_room',
      params: {'p_chat_room_id': request.chatRoomId},
      fromJson: MessageDto.fromJson,
    );
  }

  /// 새 대화 세션 생성
  Future<ConversationDto> createConversation(CreateConversationRequestDto request) async {
    return _rpcInvoker.invoke(
      functionName: 'create_chat_room',
      params: {
        'p_title': request.title,
        'p_topic_code': request.topicCode,
        'p_user_id': request.userId,
      },
      fromJson: ConversationDto.fromJson,
    );
  }

  /// 대화 삭제
  Future<void> deleteConversation(DeleteConversationRequestDto request) async {
    await _rpcInvoker.invoke(
      functionName: 'delete_chat_room',
      params: {'p_chat_room_id': request.chatRoomId},
      fromJson: (json) => json, // 리턴값이 없는 경우 빈 맵 처리
    );
  }

  /// 메시지 저장
  Future<MessageDto> saveMessage(SaveMessageRequestDto request) async {
    return _rpcInvoker.invoke(
      functionName: 'save_chat_message',
      params: {
        'p_chat_room_id': request.chatRoomId,
        'p_content': request.content,
        'p_sender_role': request.senderRole,
      },
      fromJson: MessageDto.fromJson,
    );
  }

  // ── AI 응답 스트리밍 ───────────────────────────────

  /// RPC 기반 AI 응답 스트리밍
  Stream<String> streamResponse({
    required String chatRoomId,
    required String userMessage,
    required String topicCode,
    String? personaId,
  }) async* {
    final messagesForApi = await _buildMessagesForApi(
      chatRoomId,
      userMessage,
      personaId: personaId,
    );

    yield* _rpcInvoker.invokeStream(
      functionName: 'chat',
      params: {'messages': messagesForApi},
    );
  }

  /// 대화 기록을 API 포맷으로 변환
  Future<List<Map<String, String>>> _buildMessagesForApi(
    String chatRoomId,
    String userMessage, {
    String? personaId,
  }) async {
    final history = await getMessages(GetMessagesRequestDto(chatRoomId: chatRoomId));

    final List<Map<String, String>> messages = [];

    // 1. 페르소나 추가 지침이 있는 경우 첫 번째 시스템 메시지로 삽입
    if (personaId != null) {
      final type = PersonaType.fromString(personaId);
      String? addedPrompt;
      switch (type) {
        case PersonaType.wise:
          addedPrompt = AppPersonas.wisePrompt;
        case PersonaType.friendly:
          addedPrompt = AppPersonas.friendlyPrompt;
        case PersonaType.strict:
          addedPrompt = AppPersonas.strictPrompt;
      }

      // 1.1 프롬프트 삽입
      messages.add({'role': 'system', 'content': addedPrompt});
    }

    // 2. 대화 기록 추가
    messages.addAll(history.map((m) => {
          'role': m.senderRole,
          'content': m.content,
        }));

    // 3. 현재 사용자 메시지 추가
    messages.add({'role': 'user', 'content': userMessage});

    return messages;
  }
}
