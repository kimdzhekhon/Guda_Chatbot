import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:guda_chatbot/app/config/app_config.dart';
import 'package:guda_chatbot/features/chat/data/models/conversation_dto.dart';
import 'package:guda_chatbot/features/chat/data/models/message_dto.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/domain/entities/conversation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/message.dart';

/// Supabase 채팅 데이터 소스
class SupabaseChatDataSource {
  SupabaseChatDataSource() : _supabase = Supabase.instance.client;

  final SupabaseClient _supabase;

  /// 사용자의 대화 목록 조회
  Future<List<Conversation>> getConversations() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _supabase
          .from('conversations')
          .select()
          .eq('user_id', userId)
          .order('updated_at', ascending: false);

      return (response as List)
          .map((json) =>
              ConversationDto.fromJson(json as Map<String, dynamic>).toDomain())
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// 특정 대화의 메시지 목록 조회
  Future<List<Message>> getMessages(String conversationId) async {
    try {
      final response = await _supabase
          .from('messages')
          .select()
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) =>
              MessageDto.fromJson(json as Map<String, dynamic>).toDomain())
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// 새 대화 세션 생성
  Future<Conversation> createConversation({
    required String title,
    required String classicType,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('로그인이 필요합니다.');

    final response = await _supabase
        .from('conversations')
        .insert({
          'title': title,
          'classic_type': classicType,
          'user_id': userId,
        })
        .select()
        .single();

    return ConversationDto.fromJson(response).toDomain();
  }

  /// 대화 삭제
  Future<void> deleteConversation(String conversationId) async {
    await _supabase.from('conversations').delete().eq('id', conversationId);
  }

  /// 메시지 저장
  Future<Message> saveMessage({
    required String conversationId,
    required String content,
    required String role,
  }) async {
    final response = await _supabase
        .from('messages')
        .insert({
          'conversation_id': conversationId,
          'content': content,
          'role': role,
        })
        .select()
        .single();

    return MessageDto.fromJson(response).toDomain();
  }

  /// Next.js API로 SSE 스트리밍 AI 응답
  Stream<String> streamResponse({
    required String conversationId,
    required String userMessage,
    required String classicType,
  }) {
    final controller = StreamController<String>();

    final type = ClassicType.values.firstWhere((e) => e.name == classicType);
    final apiUrl = '${AppConfig.webApiBaseUrl}${type.apiPath}';

    _streamFromApi(apiUrl, conversationId, userMessage, controller);

    return controller.stream;
  }

  /// Next.js 웹앱 API에서 SSE 스트리밍 수신
  Future<void> _streamFromApi(
    String apiUrl,
    String conversationId,
    String userMessage,
    StreamController<String> controller,
  ) async {
    try {
      // Build messages array matching the web API format
      final messagesForApi = await _buildMessagesForApi(conversationId, userMessage);

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

      // Parse SSE stream
      final lineBuffer = StringBuffer();
      await for (final chunk in response.stream.transform(utf8.decoder)) {
        lineBuffer.write(chunk);
        final lines = lineBuffer.toString().split('\n');

        // Keep last incomplete line in buffer
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
            } catch (_) {
              // Skip malformed JSON
            }
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
    String userMessage,
  ) async {
    final history = await getMessages(conversationId);

    final messages = history
        .map((m) => {
              'role': m.role == MessageRole.user ? 'user' : 'assistant',
              'content': m.content,
            })
        .toList();

    // Add current user message
    messages.add({'role': 'user', 'content': userMessage});

    return messages;
  }
}
