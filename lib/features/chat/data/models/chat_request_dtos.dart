import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_request_dtos.freezed.dart';
part 'chat_request_dtos.g.dart';

/// 대화 생성 요청 DTO
@freezed
abstract class CreateConversationRequestDto with _$CreateConversationRequestDto {
  const factory CreateConversationRequestDto({
    required String title,
    @JsonKey(name: 'topic_code') required String topicCode,
    @JsonKey(name: 'user_id') required String userId,
  }) = _CreateConversationRequestDto;

  factory CreateConversationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateConversationRequestDtoFromJson(json);
}

/// 메시지 저장 요청 DTO
@freezed
abstract class SaveMessageRequestDto with _$SaveMessageRequestDto {
  const factory SaveMessageRequestDto({
    @JsonKey(name: 'chat_rooms_id') required String chatRoomId,
    required String content,
    @JsonKey(name: 'sender_role') required String senderRole,
  }) = _SaveMessageRequestDto;

  factory SaveMessageRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SaveMessageRequestDtoFromJson(json);
}

/// 메시지 목록 조회 요청 DTO
@freezed
abstract class GetMessagesRequestDto with _$GetMessagesRequestDto {
  const factory GetMessagesRequestDto({
    @JsonKey(name: 'chat_rooms_id') required String chatRoomId,
  }) = _GetMessagesRequestDto;

  factory GetMessagesRequestDto.fromJson(Map<String, dynamic> json) =>
      _$GetMessagesRequestDtoFromJson(json);
}

/// 대화 삭제 요청 DTO
@freezed
abstract class DeleteConversationRequestDto with _$DeleteConversationRequestDto {
  const factory DeleteConversationRequestDto({
    @JsonKey(name: 'chat_rooms_id') required String chatRoomId,
  }) = _DeleteConversationRequestDto;

  factory DeleteConversationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$DeleteConversationRequestDtoFromJson(json);
}
