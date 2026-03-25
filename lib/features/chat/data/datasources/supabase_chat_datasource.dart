import 'dart:async';
<<<<<<< feature/email-auth
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:guda_chatbot/app/config/app_config.dart';
=======
>>>>>>> dev
import 'package:guda_chatbot/features/chat/data/models/conversation_dto.dart';
import 'package:guda_chatbot/features/chat/data/models/message_dto.dart';
import 'package:guda_chatbot/features/chat/data/models/chat_request_dtos.dart';

/// Supabase 채팅 데이터 소스
class SupabaseChatDataSource {
<<<<<<< feature/email-auth
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
=======
  SupabaseChatDataSource();

  // final SupabaseClient _supabase; // Supabase 연동 시 주석 해제하여 사용


  // ── 대화(Conversation) 관리 ───────────────────────
  // ── 대화(Conversation) 관리 ───────────────────────
  Future<List<ConversationDto>> getConversations() async {
    // 테스트를 위한 Mock 데이터 반환
    return [
      ConversationDto(
        id: 'mock-1',
        title: '부처님의 지혜에 대하여',
        classicType: 'tripitaka',
        userId: 'mock-user',
        createdAt: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        lastMessagePreview: '제행무상(諸行無常)의 의미는 무엇인가요?',
      ),
      ConversationDto(
        id: 'mock-2',
        title: '오늘의 운세와 주역',
        classicType: 'iching',
        userId: 'mock-user',
        createdAt: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        lastMessagePreview: '건괘가 나왔습니다. 아주 좋은 기운입니다.',
      ),
    ];
  }

  /// 특정 대화의 메시지 목록 조회
  Future<List<MessageDto>> getMessages(GetMessagesRequestDto request) async {
    if (request.conversationId == 'mock-1') {
      return [
        MessageDto(
          id: 'msg-1',
          conversationId: 'mock-1',
          role: 'user',
          content: '제행무상(諸行無常)의 의미는 무엇인가요?',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
        ),
        MessageDto(
          id: 'msg-2',
          conversationId: 'mock-1',
          role: 'assistant',
          content: '## 제행무상의 의미\n\n모든 형성된 것들은 영원하지 않다는 뜻입니다. 세상의 모든 고통은 변하는 것을 변하지 않게 잡으려는 집착에서 비롯됩니다.',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        ),
      ];
>>>>>>> dev
    }
    return [];
  }

  /// 새 대화 세션 생성
<<<<<<< feature/email-auth
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
=======
  Future<ConversationDto> createConversation(CreateConversationRequestDto request) async {
    return ConversationDto(
      id: 'mock-new-${DateTime.now().millisecondsSinceEpoch}',
      title: request.title,
      classicType: request.classicType,
      userId: 'mock-user',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
>>>>>>> dev
  }

  /// 대화 삭제
  Future<void> deleteConversation(DeleteConversationRequestDto request) async {
    // Mock에서는 아무 작업도 하지 않음
  }

  Future<MessageDto> saveMessage(SaveMessageRequestDto request) async {
    return MessageDto(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      conversationId: request.conversationId,
      role: request.role,
      content: request.content,
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  /// Next.js API로 SSE 스트리밍 AI 응답
  Stream<String> streamResponse({
    required String conversationId,
    required String userMessage,
    required String classicType,
  }) {
    final controller = StreamController<String>();

<<<<<<< feature/email-auth
    final type = ClassicType.values.firstWhere((e) => e.name == classicType);
    final apiUrl = '${AppConfig.webApiBaseUrl}${type.apiPath}';

    _streamFromApi(apiUrl, conversationId, userMessage, controller);
=======
    // 인공지능 응답 스트리밍 수신 (Edge Function 연동 전까지 Mock 데이터 사용)
    _mockStream(classicType, userMessage, controller);
>>>>>>> dev

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

<<<<<<< feature/email-auth
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
=======
  List<String> _getMockResponse(String classicType, String query) {
    final response = switch (classicType) {
      'tripitaka' =>
        '## 부처님의 말씀\n\n**금강경**에서는 "범소유상 개시허망(凡所有相 계시허망)"이라 하셨습니다.\n\n*세상의 모든 형상은 다 허망하다*는 뜻으로, 현재 겪고 계신 고민 또한 영원하지 않으며 마음이 만들어낸 그림자일 수 있음을 성찰해 보시기 바랍니다.\n\n---\n\n## 자비로운 가이던스\n\n집착을 내려놓고 고요한 마음으로 상황을 바라보세요. 마치 구름이 걷히면 달이 드러나듯, 마음의 파도가 잦아들면 해결책이 저절로 보일 것입니다.',
      'iching' =>
        '## 64괘 분석\n\n**점괘**: **건(乾)괘** — 하늘의 기운이 충만함\n\n*풀이*: 건은 원(元)하고 형(亨)하며 이(利)하고 정(貞)하니라. 하늘의 이치는 강건하니, 군자는 이를 본받아 스스로 힘쓰며 쉬지 않아야 합니다.\n\n---\n\n## 철학적 조언\n\n현재의 상황은 마치 태양이 중천에 뜬 것과 같아 매우 강력한 운때에 있습니다. 하지만 태양이 너무 뜨거우면 대지를 말리듯, 지나친 고집은 오히려 화를 부를 수 있으니 유순함을 잃지 마십시오.',
      _ =>
        '## 원전 기반 설명\n\n**구사론**에 따르면 인간의 고통은 무명(무명)에서 비롯된다고 합니다. 당신의 질문에서 느껴지는 고민은 본래 실체가 없는 것일 수 있습니다.\n\n---\n\n## 제언\n\n지각하는 주체와 대상을 분리하여 바라보는 연습을 통해 지혜로운 판단을 내리시길 권합니다.',
    };

    // 청크 단위로 나누어 스트리밍 시뮬레이션
    return response.split(' ').map((word) => '$word ').toList();
>>>>>>> dev
  }
}
