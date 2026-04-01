import 'package:guda_chatbot/features/chat/domain/entities/message.dart';
import 'package:guda_chatbot/features/chat/domain/repositories/chat_repository.dart';
import 'package:guda_chatbot/features/chat/data/models/chat_request_dtos.dart';

class GetMessagesUseCase {
  const GetMessagesUseCase(this._repository);
  final ChatRepository _repository;

  Future<List<Message>> call(String chatRoomId) =>
      _repository.getMessages(
        GetMessagesRequestDto(chatRoomId: chatRoomId),
      );
}
