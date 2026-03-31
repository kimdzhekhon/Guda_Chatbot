import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/message.dart';

part 'message_dto.freezed.dart';
part 'message_dto.g.dart';

/// 메시지 DTO — Supabase 응답을 도메인 엔티티로 변환
@freezed
abstract class MessageDto with _$MessageDto {
  const factory MessageDto({
    required int id,
    @JsonKey(name: 'chat_rooms_id') required String chatRoomId,
    @JsonKey(name: 'sender_role') required String senderRole,
    required String content,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _MessageDto;

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);

  const MessageDto._();

  Message toDomain() => Message(
    id: id,
    chatRoomId: chatRoomId,
    senderRole: senderRole == 'user' ? MessageRole.user : MessageRole.assistant,
    content: content,
    createdAt: DateTime.parse(createdAt),
  );
}

/// Edge Function 채팅 요청 DTO
@freezed
abstract class SendMessageRequestDto with _$SendMessageRequestDto {
  const factory SendMessageRequestDto({
    @JsonKey(name: 'conversation_id') required String conversationId,
    @JsonKey(name: 'user_message') required String userMessage,
    @JsonKey(name: 'classic_type') required String classicType,
  }) = _SendMessageRequestDto;

  factory SendMessageRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SendMessageRequestDtoFromJson(json);
}
