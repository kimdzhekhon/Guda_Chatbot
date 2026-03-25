import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_usage.freezed.dart';

/// 대화 사용량 엔티티
@freezed
abstract class ChatUsage with _$ChatUsage {
  const factory ChatUsage({
    /// 현재까지 사용한 대화 횟수
    required int usedCount,

    /// 총 허용 대화 횟수
    required int totalLimit,

    /// 현재 이용 중인 플랜명
    required String planName,
  }) = _ChatUsage;

  const ChatUsage._();

  /// 남은 대화 횟수 계산
  int get remainingCount => (totalLimit - usedCount).clamp(0, totalLimit);
}
