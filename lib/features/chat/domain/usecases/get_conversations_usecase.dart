import 'package:guda_chatbot/features/chat/domain/entities/conversation.dart';
import 'package:guda_chatbot/features/chat/domain/repositories/chat_repository.dart';

class GetConversationsUseCase {
  const GetConversationsUseCase(this._repository);
  final ChatRepository _repository;

  Future<List<Conversation>> call() => _repository.getConversations();
}
