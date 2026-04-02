import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guda_chatbot/features/auth/domain/entities/guda_user.dart';
import 'package:guda_chatbot/features/chat/domain/entities/persona_type.dart';

part 'auth_response_dto.freezed.dart';
part 'auth_response_dto.g.dart';

/// 인증 응답 DTO — Supabase Auth 응답을 도메인 엔티티로 변환
@freezed
abstract class AuthResponseDto with _$AuthResponseDto {
  const factory AuthResponseDto({
    required String id,
    required String email,
    @JsonKey(name: 'full_name') String? displayName,
    @JsonKey(name: 'avatar_url') String? photoUrl,
    PersonaType? persona,
    @JsonKey(name: 'terms_agreed_at') String? termsAgreedAt,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _AuthResponseDto;

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseDtoFromJson(json);

  const AuthResponseDto._();

  /// DTO → 도메인 엔티티 변환
  GudaUser toDomain() => GudaUser(
    id: id,
    email: email,
    displayName: displayName,
    photoUrl: photoUrl,
    persona: persona,
    termsAgreed: termsAgreedAt != null,
    createdAt: DateTime.parse(createdAt),
  );
}
