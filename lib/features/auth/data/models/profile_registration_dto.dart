import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_registration_dto.freezed.dart';
part 'profile_registration_dto.g.dart';

/// 프로필 등록 요청을 위한 RPC DTO
@freezed
abstract class ProfileRegistrationDto with _$ProfileRegistrationDto {
  const factory ProfileRegistrationDto({
    @JsonKey(name: 'user_id') required String userId,
    required String email,
    required String nickname,
    @JsonKey(name: 'birth_date') required String birthDate,
    required String persona,
    @JsonKey(name: 'terms_agreed_at') required String termsAgreedAt,
  }) = _ProfileRegistrationDto;

  factory ProfileRegistrationDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileRegistrationDtoFromJson(json);
}
