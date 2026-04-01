import 'package:guda_chatbot/features/auth/data/datasources/supabase_auth_datasource.dart';
import 'package:guda_chatbot/features/auth/data/models/auth_response_dto.dart';
import 'package:guda_chatbot/features/auth/domain/entities/guda_user.dart';
import 'package:guda_chatbot/features/auth/domain/repositories/auth_repository.dart';
import 'package:guda_chatbot/features/chat/domain/entities/persona_type.dart';
import 'package:guda_chatbot/features/auth/data/models/profile_registration_dto.dart';
import 'package:guda_chatbot/features/auth/data/models/persona_update_dto.dart';

/// AuthRepository 구현체 — data 레이어
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);
  final SupabaseAuthDataSource _dataSource;

  @override
  Future<GudaUser> signInWithGoogle() async {
    final dto = await _dataSource.signInWithGoogle();
    return await _getMergedUser(dto);
  }

  @override
  Future<GudaUser> signInWithApple() async {
    final dto = await _dataSource.signInWithApple();
    return await _getMergedUser(dto);
  }

  @override
  Future<void> signOut() => _dataSource.signOut();

  @override
  Future<void> deleteAccount() => _dataSource.deleteAccount();

  @override
  Future<GudaUser?> getCurrentUser() async {
    final dto = await _dataSource.getCurrentUser();
    if (dto == null) return null;
    return await _getMergedUser(dto);
  }

  @override
  Stream<GudaUser?> authStateChanges() {
    return _dataSource.authStateChanges().asyncMap((dto) async {
      if (dto == null) return null;
      return await _getMergedUser(dto);
    });
  }

  /// Supabase Auth 데이터와 profiles 테이블 데이터를 병합하여 반환
  Future<GudaUser> _getMergedUser(AuthResponseDto dto) async {
    final profile = await _dataSource.getProfile(dto.id);
    if (profile != null) {
      // DB의 email이 NULL인 경우 Supabase Auth의 이메일을 유지하도록 병합
      final Map<String, dynamic> profileData = Map.from(profile);
      if (profileData['email'] == null) {
        profileData['email'] = dto.email;
      }
      
      final mergedJson = dto.toJson()..addAll(profileData);
      return AuthResponseDto.fromJson(mergedJson).toDomain();
    }
    return dto.toDomain();
  }

  @override
  Future<void> updateProfile({
    required String nickname,
    required DateTime birthDate,
    required PersonaType persona,
    required bool termsAgreed,
  }) async {
    final user = await _dataSource.getCurrentUser();
    if (user == null) throw Exception('로그인된 사용자가 없습니다.');
    
    // architecture 규정상 DTO를 통해 RPC 데이터 전달
    final dto = ProfileRegistrationDto(
      userId: user.id,
      email: user.email, // 필수 필드로 추가됨
      nickname: nickname,
      birthDate: birthDate.toIso8601String(),
      persona: persona,
      termsAgreedAt: DateTime.now().toIso8601String(), // 현재 시각을 동의 시각으로 전송
    );

    await _dataSource.updateProfile(dto);
  }

  @override
  Future<void> updatePersona(PersonaType persona) async {
    final user = await _dataSource.getCurrentUser();
    if (user == null) throw Exception('로그인된 사용자가 없습니다.');

    final dto = PersonaUpdateDto(
      userId: user.id,
      persona: persona,
    );

    await _dataSource.updatePersona(dto);
  }
}
