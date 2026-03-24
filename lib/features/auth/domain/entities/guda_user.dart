import 'package:freezed_annotation/freezed_annotation.dart';

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

    /// 표시 이름 (Google 계정 이름)
    String? displayName,

    /// Google 프로필 사진 URL
    String? photoUrl,

    /// 계정 생성 일시
    required DateTime createdAt,
  }) = _GudaUser;
}
