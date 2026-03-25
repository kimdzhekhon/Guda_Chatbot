import 'package:guda_chatbot/features/auth/data/datasources/supabase_auth_datasource.dart';
import 'package:guda_chatbot/features/auth/domain/entities/guda_user.dart';
import 'package:guda_chatbot/features/auth/domain/repositories/auth_repository.dart';

/// AuthRepository 구현체 — data 레이어
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);
  final SupabaseAuthDataSource _dataSource;

  @override
  Future<GudaUser> signInWithGoogle() async {
    final dto = await _dataSource.signInWithGoogle();
    return dto.toDomain();
  }

  @override
  Future<GudaUser> signInWithApple() async {
    final dto = await _dataSource.signInWithApple();
    return dto.toDomain();
  }

  @override
  Future<void> signOut() => _dataSource.signOut();

  @override
  Future<void> deleteAccount() => _dataSource.deleteAccount();

  @override
  Future<GudaUser?> getCurrentUser() async {
    final dto = await _dataSource.getCurrentUser();
    return dto?.toDomain();
  }

  @override
  Stream<GudaUser?> authStateChanges() {
    return _dataSource.authStateChanges().map((dto) => dto?.toDomain());
  }
}
