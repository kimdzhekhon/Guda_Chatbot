import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/chat_usage.dart';
import 'package:guda_chatbot/features/chat/domain/entities/message.dart';

part 'save_message_result.freezed.dart';

/// 메시지 저장 결과 — 메시지 + 사용량 (user 메시지일 때만 usage 포함)
@freezed
abstract class SaveMessageResult with _$SaveMessageResult {
  const factory SaveMessageResult({
    required Message message,

    /// user 메시지일 때만 non-null (크레딧 차감 결과)
    ChatUsage? usage,
  }) = _SaveMessageResult;
}
