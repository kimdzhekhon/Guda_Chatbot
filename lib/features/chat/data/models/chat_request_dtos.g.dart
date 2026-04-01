// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_request_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateConversationRequestDto _$CreateConversationRequestDtoFromJson(
  Map<String, dynamic> json,
) => _CreateConversationRequestDto(
  title: json['title'] as String,
  topicCode: json['topic_code'] as String,
  userId: json['user_id'] as String,
  personaId: json['persona_id'] as String,
  hexagramId: json['hexagram_id'] as String?,
);

Map<String, dynamic> _$CreateConversationRequestDtoToJson(
  _CreateConversationRequestDto instance,
) => <String, dynamic>{
  'title': instance.title,
  'topic_code': instance.topicCode,
  'user_id': instance.userId,
  'persona_id': instance.personaId,
  'hexagram_id': instance.hexagramId,
};

_SaveMessageRequestDto _$SaveMessageRequestDtoFromJson(
  Map<String, dynamic> json,
) => _SaveMessageRequestDto(
  chatRoomId: json['chat_rooms_id'] as String,
  content: json['content'] as String,
  senderRole: json['sender_role'] as String,
);

Map<String, dynamic> _$SaveMessageRequestDtoToJson(
  _SaveMessageRequestDto instance,
) => <String, dynamic>{
  'chat_rooms_id': instance.chatRoomId,
  'content': instance.content,
  'sender_role': instance.senderRole,
};

_GetMessagesRequestDto _$GetMessagesRequestDtoFromJson(
  Map<String, dynamic> json,
) => _GetMessagesRequestDto(chatRoomId: json['chat_rooms_id'] as String);

Map<String, dynamic> _$GetMessagesRequestDtoToJson(
  _GetMessagesRequestDto instance,
) => <String, dynamic>{'chat_rooms_id': instance.chatRoomId};

_DeleteConversationRequestDto _$DeleteConversationRequestDtoFromJson(
  Map<String, dynamic> json,
) => _DeleteConversationRequestDto(chatRoomId: json['chat_rooms_id'] as String);

Map<String, dynamic> _$DeleteConversationRequestDtoToJson(
  _DeleteConversationRequestDto instance,
) => <String, dynamic>{'chat_rooms_id': instance.chatRoomId};
