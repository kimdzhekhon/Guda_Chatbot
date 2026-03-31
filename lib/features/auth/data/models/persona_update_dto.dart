import 'package:freezed_annotation/freezed_annotation.dart';

part 'persona_update_dto.freezed.dart';
part 'persona_update_dto.g.dart';

/// 페르소나 업데이트 요청을 위한 RPC DTO
@freezed
abstract class PersonaUpdateDto with _$PersonaUpdateDto {
  const factory PersonaUpdateDto({
    @JsonKey(name: 'user_id') required String userId,
    required String persona,
  }) = _PersonaUpdateDto;

  factory PersonaUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$PersonaUpdateDtoFromJson(json);
}
