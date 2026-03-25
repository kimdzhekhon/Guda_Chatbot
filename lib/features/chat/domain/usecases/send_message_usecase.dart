import 'package:guda_chatbot/features/chat/domain/repositories/chat_repository.dart';
import 'package:guda_chatbot/features/chat/data/models/chat_request_dtos.dart';

class SendMessageUseCase {
  const SendMessageUseCase(this._repository);
  final ChatRepository _repository;

  /// 메시지 저장 및 스트리밍 응답 획득의 오케스트레이션
  /// 본 프로젝트 규칙 5.b에 따라 복합 플로우는 Orchestration 또는 UseCase로 처리
  Stream<String> call({
    required String conversationId,
    required String content,
    required String classicType,
  }) async* {
    // 1. 사용자 메시지 저장
    await _repository.saveMessage(
      SaveMessageRequestDto(
        conversationId: conversationId,
        content: content,
        role: 'user',
      ),
    );

    // 2. AI 응답 스트리밍
    yield* _repository.streamResponse(
      conversationId: conversationId,
      userMessage: content,
      classicType: classicType,
    );
  }
}
