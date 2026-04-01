import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/persona_type.dart';

part 'profile_registration_dto.freezed.dart';
part 'profile_registration_dto.g.dart';

/// 프로필 등록 요청을 위한 RPC DTO
@freezed
abstract class ProfileRegistrationDto with _$ProfileRegistrationDto {
  const factory ProfileRegistrationDto({
    @JsonKey(name: 'p_user_id') required String userId,
    @JsonKey(name: 'p_persona') required PersonaType persona,
    @JsonKey(name: 'p_terms_agreed_at') required String termsAgreedAt,
  }) = _ProfileRegistrationDto;

  factory ProfileRegistrationDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileRegistrationDtoFromJson(json);
}
