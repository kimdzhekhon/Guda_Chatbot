import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:guda_chatbot/features/chat/data/models/conversation_dto.dart';
import 'package:guda_chatbot/features/chat/data/models/message_dto.dart';
import 'package:guda_chatbot/features/chat/data/models/chat_request_dtos.dart';
import 'package:guda_chatbot/core/constants/app_personas.dart';
import 'package:guda_chatbot/features/chat/domain/entities/persona_type.dart';
import 'package:guda_chatbot/features/chat/domain/entities/chat_usage.dart';
import 'package:guda_chatbot/features/chat/domain/entities/save_message_result.dart';

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
        'p_persona_id': request.personaId,
        'p_hexagram_id': request.hexagramId,
      },
      fromJson: ConversationDto.fromJson,
    );
  }

  /// 대화 삭제
  Future<void> deleteConversation(DeleteConversationRequestDto request) async {
    await _rpcInvoker.invokeVoid(
      functionName: 'delete_chat_room',
      params: {'p_chat_room_id': request.chatRoomId},
    );
  }

  /// 메시지 저장 (user 메시지일 때 크레딧 차감 + 로그 기록 포함)
  Future<SaveMessageResult> saveMessage(SaveMessageRequestDto request) async {
    return _rpcInvoker.invoke(
      functionName: 'save_chat_message',
      params: {
        'p_chat_room_id': request.chatRoomId,
        'p_content': request.content,
        'p_sender_role': request.senderRole,
      },
      fromJson: (json) {
        final msgDto = MessageDto.fromJson(json['message'] as Map<String, dynamic>);
        final usageJson = json['usage'] as Map<String, dynamic>?;
        ChatUsage? usage;
        if (usageJson != null) {
          usage = ChatUsage(
            usedCount: (usageJson['total_limit'] as num).toInt() - (usageJson['remaining_count'] as num).toInt(),
            totalLimit: (usageJson['total_limit'] as num).toInt(),
            planName: _mapPlanName(usageJson['plan_name'] as String),
          );
        }
        return SaveMessageResult(message: msgDto.toDomain(), usage: usage);
      },
    );
  }

  // ── 대화 사용량 관리 ───────────────────────────────

  String _mapPlanName(String plan) => plan == 'None' ? 'Free' : plan;

  /// 대화 사용량 조회
  Future<ChatUsage> getChatUsage() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      return const ChatUsage(usedCount: 0, totalLimit: 0, planName: 'Free');
    }

    return _rpcInvoker.invoke(
      functionName: 'get_chat_usage',
      params: {'p_user_id': userId},
      fromJson: (json) => ChatUsage(
        usedCount: (json['total_limit'] as num).toInt() - (json['remaining_count'] as num).toInt(),
        totalLimit: (json['total_limit'] as num).toInt(),
        planName: _mapPlanName(json['plan_name'] as String),
      ),
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
    // 앱 시작 직후 토큰 만료 문제를 방지하기 위해 세션 갱신 시도
    try {
      await _supabase.auth.refreshSession();
    } catch (_) {
      // 세션 갱신 실패 시에도 일단 진행 (익명 사용자 등 고려)
    }

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

    // 0. 주역 괘 정보 조회 및 AI 가이드 추가
    final chatRoom = await _supabase
        .from('chat_rooms')
        .select('hexagram_id, topic_code')
        .eq('id', chatRoomId)
        .single();
    
    final hexagramName = chatRoom['hexagram_id'] as String?;
    final topicCode = chatRoom['topic_code'] as String?;

    if (topicCode == 'iching' && hexagramName != null) {
      messages.add({
        'role': 'system', 
        'content': '주역 대화입니다. 사용자가 뽑은 괘는 \'$hexagramName\'입니다. 이 괘의 의미를 깊이 있게 풀이하여 사용자의 고민에 답해주세요.'
      });
    }

    // 1. 페르소나 추가 지침이 있는 경우 시스템 메시지로 삽입
    if (personaId != null) {
      final type = PersonaType.fromString(personaId);
      String? addedPrompt;
      switch (type) {
        case PersonaType.basic:
          addedPrompt = AppPersonas.basicPrompt;
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
