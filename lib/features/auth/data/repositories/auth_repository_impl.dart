import 'package:guda_chatbot/features/auth/data/datasources/supabase_auth_datasource.dart';
import 'package:guda_chatbot/features/auth/domain/entities/guda_user.dart';
import 'package:guda_chatbot/features/auth/domain/repositories/auth_repository.dart';

/// AuthRepository 구현체 — data 레이어
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);
  final SupabaseAuthDataSource _dataSource;

  @override
  Future<GudaUser> signInWithEmail(String email, String password) =>
      _dataSource.signInWithEmail(email, password);

  @override
  Future<GudaUser> signUpWithEmail(String email, String password) =>
      _dataSource.signUpWithEmail(email, password);

  @override
  Future<GudaUser> signInWithGoogle() => _dataSource.signInWithGoogle();

  @override
  Future<GudaUser> signInWithApple() => _dataSource.signInWithApple();

  @override
  Future<void> signOut() => _dataSource.signOut();

  @override
  Future<GudaUser?> getCurrentUser() => _dataSource.getCurrentUser();

  @override
  Stream<GudaUser?> authStateChanges() => _dataSource.authStateChanges();
}
