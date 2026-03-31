// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) => _MessageDto(
  id: (json['id'] as num).toInt(),
  chatRoomId: json['chat_rooms_id'] as String,
  senderRole: json['sender_role'] as String,
  content: json['content'] as String,
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$MessageDtoToJson(_MessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chat_rooms_id': instance.chatRoomId,
      'sender_role': instance.senderRole,
      'content': instance.content,
      'created_at': instance.createdAt,
    };

_SendMessageRequestDto _$SendMessageRequestDtoFromJson(
  Map<String, dynamic> json,
) => _SendMessageRequestDto(
  conversationId: json['conversation_id'] as String,
  userMessage: json['user_message'] as String,
  classicType: json['classic_type'] as String,
);

Map<String, dynamic> _$SendMessageRequestDtoToJson(
  _SendMessageRequestDto instance,
) => <String, dynamic>{
  'conversation_id': instance.conversationId,
  'user_message': instance.userMessage,
  'classic_type': instance.classicType,
};
