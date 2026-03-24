import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
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
    final currentUser = _supabase.auth.currentUser;
    final userId = currentUser?.id ?? 'mock-1234'; // Mock 지원을 위해 기본 ID 사용

    try {
      final response = await _supabase
          .from('conversations')
          .select()
          .eq('user_id', userId)
          .order('updated_at', ascending: false);

      return (response as List)
          .map(
            (json) =>
                ConversationDto.fromJson(json as Map<String, dynamic>).toDomain(),
          )
          .toList();
    } catch (e) {
      // 테이블이 없거나 권한 문제가 있을 경우 빈 목록 반환 (테스트 환경 고려)
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
          .map(
            (json) =>
                MessageDto.fromJson(json as Map<String, dynamic>).toDomain(),
          )
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
    final userId = _supabase.auth.currentUser?.id ?? 'mock-1234';

    // 실제 Supabase 연결 시도
    try {
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
    } catch (e) {
      // 실제 DB 연동 실패 시 Mock 데이터 반환 (UI 흐름 테스트용)
      return Conversation(
        id: 'mock-conv-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        classicType: ClassicType.values.firstWhere((e) => e.name == classicType),
        userId: userId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
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

  /// Edge Function 스트리밍 AI 응답
  /// Supabase Edge Function에서 SSE(Server-Sent Events) 형식으로 스트리밍 응답 수신
  Stream<String> streamResponse({
    required String conversationId,
    required String userMessage,
    required String classicType,
  }) {
    final controller = StreamController<String>();

    // TODO: Edge Function 배포 후 실제 스트리밍 연동
    // 현재는 Mock 데이터 스트리밍으로 동작
    _mockStream(classicType, userMessage, controller);

    return controller.stream;
  }

  /// Mock 스트리밍 — Edge Function 연동 전 테스트용
  Future<void> _mockStream(
    String classicType,
    String query,
    StreamController<String> controller,
  ) async {
    final responses = _getMockResponse(classicType, query);
    for (final chunk in responses) {
      await Future.delayed(const Duration(milliseconds: 40));
      if (!controller.isClosed) controller.add(chunk);
    }
    if (!controller.isClosed) controller.close();
  }

  List<String> _getMockResponse(String classicType, String query) {
    final response = switch (classicType) {
      'tripitaka' =>
        '## 📿 부처님의 말씀\n\n**금강경**에서는 "범소유상 개시허망(凡所有相 皆是虛妄)"이라 하셨습니다.\n\n*세상의 모든 형상은 다 허망하다*는 뜻으로, 현재 겪고 계신 고민 또한 영원하지 않으며 마음이 만들어낸 그림자일 수 있음을 성찰해 보시기 바랍니다.\n\n---\n\n## 💡 자비로운 가이던스\n\n집착을 내려놓고 고요한 마음으로 상황을 바라보세요. 마치 구름이 걷히면 달이 드러나듯, 마음의 파도가 잦아들면 해결책이 저절로 보일 것입니다.',
      'iching' =>
        '## 🔮 64괘 분석\n\n**점괘**: **건(乾)괘** — 하늘의 기운이 충만함\n\n*풀이*: 건은 원(元)하고 형(亨)하며 이(利)하고 정(貞)하니라. 하늘의 이치는 강건하니, 군자는 이를 본받아 스스로 힘쓰며 쉬지 않아야 합니다.\n\n---\n\n## 📜 철학적 조언\n\n현재의 상황은 마치 태양이 중천에 뜬 것과 같아 매우 강력한 운때에 있습니다. 하지만 태양이 너무 뜨거우면 대지를 말리듯, 지나친 고집은 오히려 화를 부를 수 있으니 유순함을 잃지 마십시오.',
      _ =>
        '## 📖 원전 기반 설명\n\n**구사론**에 따르면 인간의 고통은 무명(無明)에서 비롯된다고 합니다. 당신의 질문에서 느껴지는 고민은 본래 실체가 없는 것일 수 있습니다.\n\n---\n\n## 💡 제언\n\n지각하는 주체와 대상을 분리하여 바라보는 연습을 통해 지혜로운 판단을 내리시길 권합니다.',
    };

    // 청크 단위로 나누어 스트리밍 시뮬레이션
    return response.split(' ').map((word) => '$word ').toList();
  }
}
