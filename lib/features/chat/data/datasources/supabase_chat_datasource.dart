import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:guda_chatbot/app/config/app_config.dart';
import 'package:guda_chatbot/features/chat/data/models/conversation_dto.dart';
import 'package:guda_chatbot/features/chat/data/models/message_dto.dart';
import 'package:guda_chatbot/features/chat/data/models/chat_request_dtos.dart';
import 'package:guda_chatbot/core/constants/app_personas.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';

/// Supabase 채팅 데이터 소스
class SupabaseChatDataSource {
  SupabaseChatDataSource() : _supabase = Supabase.instance.client;

  final SupabaseClient _supabase;

  // ── 대화(Conversation) 관리 ───────────────────────
  
  /// 사용자의 대화 목록 조회
  Future<List<ConversationDto>> getConversations() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _supabase
          .from('conversations')
          .select()
          .eq('user_id', userId)
          .order('updated_at', ascending: false);

      return (response as List)
          .map((json) => ConversationDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// 특정 대화의 메시지 목록 조회
  Future<List<MessageDto>> getMessages(GetMessagesRequestDto request) async {
    try {
      final response = await _supabase
          .from('messages')
          .select()
          .eq('conversation_id', request.conversationId)
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => MessageDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// 새 대화 세션 생성
  Future<ConversationDto> createConversation(CreateConversationRequestDto request) async {
    final response = await _supabase
        .from('conversations')
        .insert({
          'title': request.title,
          'classic_type': request.classicType,
          'user_id': request.userId,
        })
        .select()
        .single();

    return ConversationDto.fromJson(response);
  }

  /// 대화 삭제
  Future<void> deleteConversation(DeleteConversationRequestDto request) async {
    await _supabase
        .from('conversations')
        .delete()
        .eq('id', request.conversationId);
  }

  /// 메시지 저장
  Future<MessageDto> saveMessage(SaveMessageRequestDto request) async {
    final response = await _supabase
        .from('messages')
        .insert({
          'conversation_id': request.conversationId,
          'content': request.content,
          'role': request.role,
        })
        .select()
        .single();

    return MessageDto.fromJson(response);
  }

  // ── AI 응답 스트리밍 ───────────────────────────────

  /// Next.js API로 SSE 스트리밍 AI 응답
  Stream<String> streamResponse({
    required String conversationId,
    required String userMessage,
    required String classicType,
    String? personaId,
  }) {
    final controller = StreamController<String>();

    final type = ClassicType.values.firstWhere((e) => e.name == classicType);
    final apiUrl = '${AppConfig.webApiBaseUrl}${type.apiPath}';

    _streamFromApi(apiUrl, conversationId, userMessage, controller, personaId: personaId);

    return controller.stream;
  }

  /// Next.js 웹앱 API에서 SSE 스트리밍 수신
  Future<void> _streamFromApi(
    String apiUrl,
    String conversationId,
    String userMessage,
    StreamController<String> controller, {
    String? personaId,
  }) async {
    try {
      final messagesForApi = await _buildMessagesForApi(
        conversationId,
        userMessage,
        personaId: personaId,
      );

      final request = http.Request('POST', Uri.parse(apiUrl));
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode({'messages': messagesForApi});

      final response = await http.Client().send(request);

      if (response.statusCode != 200) {
        if (!controller.isClosed) {
          controller.addError('서버 오류가 발생했습니다 (${response.statusCode})');
          controller.close();
        }
        return;
      }

      final lineBuffer = StringBuffer();
      await for (final chunk in response.stream.transform(utf8.decoder)) {
        lineBuffer.write(chunk);
        final lines = lineBuffer.toString().split('\n');

        lineBuffer.clear();
        if (!chunk.endsWith('\n')) {
          lineBuffer.write(lines.removeLast());
        }

        for (final line in lines) {
          final trimmed = line.trim();
          if (trimmed.isEmpty) continue;

          if (trimmed == 'data: [DONE]') {
            if (!controller.isClosed) controller.close();
            return;
          }

          if (trimmed.startsWith('data: ')) {
            try {
              final jsonStr = trimmed.substring(6);
              final data = jsonDecode(jsonStr) as Map<String, dynamic>;
              if (data.containsKey('text') && !controller.isClosed) {
                controller.add(data['text'] as String);
              }
            } catch (_) {}
          }
        }
      }

      if (!controller.isClosed) controller.close();
    } catch (e) {
      if (!controller.isClosed) {
        controller.addError('연결 오류: ${e.toString()}');
        controller.close();
      }
    }
  }

  /// 대화 기록을 API 포맷으로 변환
  Future<List<Map<String, String>>> _buildMessagesForApi(
    String conversationId,
    String userMessage, {
    String? personaId,
  }) async {
    final history = await getMessages(GetMessagesRequestDto(conversationId: conversationId));

    final List<Map<String, String>> messages = [];

    // 1. 페르소나 추가 지침이 있는 경우 첫 번째 시스템 메시지로 삽입
    if (personaId != null) {
      String? addedPrompt;
      if (personaId == 'wise') addedPrompt = AppPersonas.wisePrompt;
      if (personaId == 'friendly') addedPrompt = AppPersonas.friendlyPrompt;
      if (personaId == 'strict') addedPrompt = AppPersonas.strictPrompt;

      if (addedPrompt != null) {
        messages.add({'role': 'system', 'content': addedPrompt});
      }
    }

    // 2. 대화 기록 추가
    messages.addAll(history.map((m) => {
          'role': m.role,
          'content': m.content,
        }));

    // 3. 현재 사용자 메시지 추가
    messages.add({'role': 'user', 'content': userMessage});

    return messages;
  }
}
