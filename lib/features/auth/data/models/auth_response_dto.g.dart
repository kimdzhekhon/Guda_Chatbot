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
      persona: $enumDecodeNullable(_$PersonaTypeEnumMap, json['persona']),
      termsAgreedAt: json['terms_agreed_at'] as String?,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$AuthResponseDtoToJson(_AuthResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'full_name': instance.displayName,
      'avatar_url': instance.photoUrl,
      'persona': _$PersonaTypeEnumMap[instance.persona],
      'terms_agreed_at': instance.termsAgreedAt,
      'created_at': instance.createdAt,
    };

const _$PersonaTypeEnumMap = {
  PersonaType.basic: 'basic',
  PersonaType.friendly: 'friendly',
  PersonaType.strict: 'strict',
};
