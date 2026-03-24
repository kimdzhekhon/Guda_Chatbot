import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';

/// 메시지 발신자 역할
enum MessageRole {
  /// 사용자 메시지
  user,

  /// AI 응답 메시지
  assistant,
}

/// 메시지 엔티티 (도메인 레이어)
@freezed
abstract class Message with _$Message {
  const factory Message({
    /// 메시지 UUID
    required String id,

    /// 소속 대화 세션 ID
    required String conversationId,

    /// 발신자 역할
    required MessageRole role,

    /// 메시지 내용 (마크다운 지원)
    required String content,

    /// 생성 일시
    required DateTime createdAt,

    /// 스트리밍 중 여부 (렌더링 시 점진적 텍스트 표시)
    @Default(false) bool isStreaming,
  }) = _Message;
}
