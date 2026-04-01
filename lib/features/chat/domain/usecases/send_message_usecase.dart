import 'package:guda_chatbot/features/chat/domain/entities/persona_type.dart';
import 'package:guda_chatbot/features/chat/domain/entities/save_message_result.dart';
import 'package:guda_chatbot/features/chat/domain/repositories/chat_repository.dart';
import 'package:guda_chatbot/features/chat/data/models/chat_request_dtos.dart';

/// 메시지 저장 결과와 AI 스트리밍을 함께 전달하는 래퍼
class SendMessageResponse {
  const SendMessageResponse({required this.saveResult, required this.stream});

  /// 메시지 저장 + 크레딧 차감 결과
  final SaveMessageResult saveResult;

  /// AI 응답 스트리밍
  final Stream<String> stream;
}

class SendMessageUseCase {
  const SendMessageUseCase(this._repository);
  final ChatRepository _repository;

  /// 메시지 저장(크레딧 차감 포함) 및 스트리밍 응답 획득
  Future<SendMessageResponse> call({
    required String chatRoomId,
    required String content,
    required String topicCode,
    PersonaType? personaId,
  }) async {
    // 1. 사용자 메시지 저장 (크레딧 차감 + 로그 기록 포함)
    final saveResult = await _repository.saveMessage(
      SaveMessageRequestDto(
        chatRoomId: chatRoomId,
        content: content,
        senderRole: 'user',
      ),
    );

    // 2. AI 응답 스트리밍
    final stream = _repository.streamResponse(
      chatRoomId: chatRoomId,
      userMessage: content,
      topicCode: topicCode,
      personaId: personaId,
    );

    return SendMessageResponse(saveResult: saveResult, stream: stream);
  }
}
