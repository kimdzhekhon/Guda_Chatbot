import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:guda_chatbot/features/chat/domain/entities/conversation.dart';
import 'package:guda_chatbot/features/chat/domain/repositories/chat_repository.dart';
import 'package:guda_chatbot/features/chat/data/models/chat_request_dtos.dart';

class CreateConversationUseCase {
  const CreateConversationUseCase(this._repository);
  final ChatRepository _repository;

  Future<Conversation> call({
    required String title,
    required String classicType,
  }) {
    final userId = Supabase.instance.client.auth.currentUser?.id ?? 'mock-1234';

    return _repository.createConversation(
      CreateConversationRequestDto(
        title: title,
        classicType: classicType,
        userId: userId,
      ),
    );
  }
}
