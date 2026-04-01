// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Bookmark _$BookmarkFromJson(Map<String, dynamic> json) => _Bookmark(
  id: json['id'] as String,
  userId: json['userId'] as String,
  title: json['title'] as String,
  content: json['content'] as String,
  type: $enumDecode(_$BookmarkTypeEnumMap, json['type']),
  referenceId: json['referenceId'] as String,
  chatRoomId: json['chatRoomId'] as String?,
  topicCode: $enumDecodeNullable(_$ClassicTypeEnumMap, json['topicCode']),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$BookmarkToJson(_Bookmark instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'title': instance.title,
  'content': instance.content,
  'type': _$BookmarkTypeEnumMap[instance.type]!,
  'referenceId': instance.referenceId,
  'chatRoomId': instance.chatRoomId,
  'topicCode': _$ClassicTypeEnumMap[instance.topicCode],
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$BookmarkTypeEnumMap = {
  BookmarkType.message: 'message',
  BookmarkType.hexagram: 'hexagram',
};

const _$ClassicTypeEnumMap = {
  ClassicType.tripitaka: 'tripitaka',
  ClassicType.iching: 'iching',
};
