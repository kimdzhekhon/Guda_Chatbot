import 'package:guda_chatbot/features/chat/domain/repositories/chat_repository.dart';

class DeleteConversationUseCase {
  const DeleteConversationUseCase(this._repository);
  final ChatRepository _repository;

  Future<void> call(String conversationId) =>
      _repository.deleteConversation(conversationId);
}
