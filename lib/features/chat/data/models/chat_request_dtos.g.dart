// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_request_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateConversationRequestDto _$CreateConversationRequestDtoFromJson(
  Map<String, dynamic> json,
) => _CreateConversationRequestDto(
  title: json['title'] as String,
  classicType: json['classic_type'] as String,
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$CreateConversationRequestDtoToJson(
  _CreateConversationRequestDto instance,
) => <String, dynamic>{
  'title': instance.title,
  'classic_type': instance.classicType,
  'user_id': instance.userId,
};

_SaveMessageRequestDto _$SaveMessageRequestDtoFromJson(
  Map<String, dynamic> json,
) => _SaveMessageRequestDto(
  conversationId: json['conversation_id'] as String,
  content: json['content'] as String,
  role: json['role'] as String,
);

Map<String, dynamic> _$SaveMessageRequestDtoToJson(
  _SaveMessageRequestDto instance,
) => <String, dynamic>{
  'conversation_id': instance.conversationId,
  'content': instance.content,
  'role': instance.role,
};
