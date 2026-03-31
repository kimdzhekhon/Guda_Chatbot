import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/persona_type.dart';

part 'guda_user.freezed.dart';

/// Guda 사용자 도메인 엔티티
/// Flutter 의존성 없는 순수 Dart 클래스
@freezed
abstract class GudaUser with _$GudaUser {
  const factory GudaUser({
    /// Supabase 사용자 UUID
    required String id,

    /// 이메일 주소
    required String email,

    /// 표시 이름 (기본값: Google 계정 이름)
    String? displayName,

    /// Google 프로필 사진 URL
    String? photoUrl,

    /// 닉네임 (사용자 설정)
    String? nickname,

    /// 생년월일
    DateTime? birthDate,

    /// 페르소나 (PersonaType: wise, friendly, strict)
    PersonaType? persona,

    /// 약관 동의 여부
    @Default(false) bool termsAgreed,

    /// 계정 생성 일시
    required DateTime createdAt,
  }) = _GudaUser;

  const GudaUser._();

  /// 모든 필수 정보(닉네임, 생년월일, 페르소나, 약관동의)가 작성되었는지 확인
  bool get isProfileComplete =>
      nickname != null &&
      nickname!.isNotEmpty &&
      birthDate != null &&
      persona != null &&
      termsAgreed;
}
