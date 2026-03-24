// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthResponseDto _$AuthResponseDtoFromJson(Map<String, dynamic> json) =>
    _AuthResponseDto(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['full_name'] as String?,
      photoUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$AuthResponseDtoToJson(_AuthResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'full_name': instance.displayName,
      'avatar_url': instance.photoUrl,
      'created_at': instance.createdAt,
    };
