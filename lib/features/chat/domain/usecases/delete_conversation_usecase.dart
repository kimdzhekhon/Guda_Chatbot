import 'package:guda_chatbot/features/chat/domain/repositories/chat_repository.dart';
import 'package:guda_chatbot/features/chat/data/models/chat_request_dtos.dart';

class DeleteConversationUseCase {
  const DeleteConversationUseCase(this._repository);
  final ChatRepository _repository;

  Future<void> call(String conversationId) =>
      _repository.deleteConversation(
        DeleteConversationRequestDto(conversationId: conversationId),
      );
}
