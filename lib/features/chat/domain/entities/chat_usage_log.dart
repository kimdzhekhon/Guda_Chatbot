import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_usage_log.freezed.dart';

@freezed
abstract class ChatUsageLog with _$ChatUsageLog {
  const factory ChatUsageLog({
    required int id,
    required String action, // 'credit_used', 'credit_charged', etc.
    required int amount,
    required int remaining,
    required DateTime createdAt,
    String? chatRoomTitle,
  }) = _ChatUsageLog;

  const ChatUsageLog._();

  /// 사용량 증감 구분
  bool get isDeduction => action.contains('used') || action.contains('expired');
  bool get isCharge => action.contains('charged');
}
