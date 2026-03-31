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
      nickname: json['nickname'] as String?,
      birthDate: json['birth_date'] as String?,
      persona: json['persona'] as String?,
      termsAgreedAt: json['terms_agreed_at'] as String?,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$AuthResponseDtoToJson(_AuthResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'full_name': instance.displayName,
      'avatar_url': instance.photoUrl,
      'nickname': instance.nickname,
      'birth_date': instance.birthDate,
      'persona': instance.persona,
      'terms_agreed_at': instance.termsAgreedAt,
      'created_at': instance.createdAt,
    };
