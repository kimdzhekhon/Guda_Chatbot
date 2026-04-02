import 'package:guda_chatbot/features/chat/domain/entities/chat_usage_log.dart';
import 'package:guda_chatbot/features/chat/domain/repositories/chat_repository.dart';

/// 대화 사용 로그를 가져오는 유즈케이스
class GetChatUsageLogsUseCase {
  final ChatRepository _repository;

  GetChatUsageLogsUseCase(this._repository);

  Future<List<ChatUsageLog>> execute() async {
    return await _repository.getChatUsageLogs();
  }
}
