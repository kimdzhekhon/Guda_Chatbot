// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConversationDto _$ConversationDtoFromJson(Map<String, dynamic> json) =>
    _ConversationDto(
      id: json['id'] as String,
      title: json['title'] as String,
      classicType: json['classic_type'] as String,
      userId: json['user_id'] as String,
      lastMessagePreview: json['last_message_preview'] as String?,
      messageCount: (json['message_count'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$ConversationDtoToJson(_ConversationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'classic_type': instance.classicType,
      'user_id': instance.userId,
      'last_message_preview': instance.lastMessagePreview,
      'message_count': instance.messageCount,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
