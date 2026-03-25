import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_request_dtos.freezed.dart';
part 'chat_request_dtos.g.dart';

/// 대화 생성 요청 DTO
@freezed
abstract class CreateConversationRequestDto with _$CreateConversationRequestDto {
  const factory CreateConversationRequestDto({
    required String title,
    @JsonKey(name: 'classic_type') required String classicType,
    @JsonKey(name: 'user_id') required String userId,
  }) = _CreateConversationRequestDto;

  factory CreateConversationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateConversationRequestDtoFromJson(json);
}

/// 메시지 저장 요청 DTO
@freezed
abstract class SaveMessageRequestDto with _$SaveMessageRequestDto {
  const factory SaveMessageRequestDto({
    @JsonKey(name: 'conversation_id') required String conversationId,
    required String content,
    required String role,
  }) = _SaveMessageRequestDto;

  factory SaveMessageRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SaveMessageRequestDtoFromJson(json);
}

/// 메시지 목록 조회 요청 DTO
@freezed
abstract class GetMessagesRequestDto with _$GetMessagesRequestDto {
  const factory GetMessagesRequestDto({
    @JsonKey(name: 'conversation_id') required String conversationId,
  }) = _GetMessagesRequestDto;

  factory GetMessagesRequestDto.fromJson(Map<String, dynamic> json) =>
      _$GetMessagesRequestDtoFromJson(json);
}

/// 대화 삭제 요청 DTO
@freezed
abstract class DeleteConversationRequestDto with _$DeleteConversationRequestDto {
  const factory DeleteConversationRequestDto({
    @JsonKey(name: 'conversation_id') required String conversationId,
  }) = _DeleteConversationRequestDto;

  factory DeleteConversationRequestDto.fromJson(Map<String, dynamic> json) =>
      _$DeleteConversationRequestDtoFromJson(json);
}
