import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_usage.freezed.dart';

/// 대화 사용량 엔티티
@freezed
abstract class ChatUsage with _$ChatUsage {
  const factory ChatUsage({
    /// 남은 대화 횟수 (DB 원천 데이터)
    required int remainingCount,

    /// 총 허용 대화 횟수
    required int totalLimit,

    /// 현재 이용 중인 플랜명
    required String planName,

    /// 현재 구독 중인 상품 ID
    String? productId,
  }) = _ChatUsage;

  const ChatUsage._();

  /// 현재까지 사용한 대화 횟수 계산
  int get usedCount => (totalLimit - remainingCount).clamp(0, totalLimit);
}
