import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:guda_chatbot/features/chat/domain/entities/conversation.dart';
import 'package:guda_chatbot/features/chat/domain/repositories/chat_repository.dart';
import 'package:guda_chatbot/features/chat/data/models/chat_request_dtos.dart';

class CreateConversationUseCase {
  const CreateConversationUseCase(this._repository);
  final ChatRepository _repository;

  Future<Conversation> call({
    required String title,
    required String topicCode,
  }) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('로그인이 필요합니다.');
    }

    return _repository.createConversation(
      CreateConversationRequestDto(
        title: title,
        topicCode: topicCode,
        userId: user.id,
      ),
    );
  }
}
