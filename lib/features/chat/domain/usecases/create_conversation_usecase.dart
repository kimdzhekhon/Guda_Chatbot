import 'package:guda_chatbot/features/chat/domain/entities/conversation.dart';
import 'package:guda_chatbot/features/chat/domain/repositories/chat_repository.dart';

class CreateConversationUseCase {
  const CreateConversationUseCase(this._repository);
  final ChatRepository _repository;

  Future<Conversation> call({
    required String title,
    required String classicType,
  }) {
    return _repository.createConversation(
      title: title,
      classicType: classicType,
    );
  }
}
