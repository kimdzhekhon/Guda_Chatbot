import 'package:guda_chatbot/features/chat/domain/entities/chat_usage_log.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_viewmodels.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'usage_history_viewmodel.g.dart';

@riverpod
class UsageHistoryViewModel extends _$UsageHistoryViewModel {
  @override
  Future<List<ChatUsageLog>> build() async {
    return _loadLogs();
  }

  Future<List<ChatUsageLog>> _loadLogs() async {
    final useCase = ref.read(getChatUsageLogsUseCaseProvider);
    return await useCase.execute();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadLogs());
  }
}
