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
    /// 메시지 고유 ID (PK)
    required int id,

    /// 소속 채팅방 ID
    required String chatRoomId,

    /// 발신자 역할
    required MessageRole senderRole,

    /// 메시지 내용 (마크다운 지원)
    required String content,

    /// 생성 일시
    required DateTime createdAt,

    /// 스트리밍 중 여부 (렌더링 시 점진적 텍스트 표시)
    @Default(false) bool isStreaming,

    /// 시스템 메시지 여부 (북마크/공유 액션 버튼 비노출용)
    @Default(false) bool isSystem,
  }) = _Message;
}
