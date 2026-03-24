import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// GudaSecureStorage — 민감한 정보 보관을 위한 SecureStorage 래퍼
/// 인증 토큰, 세션 데이터 등 모든 민감 데이터는 이 클래스를 통해 접근
class GudaSecureStorage {
  const GudaSecureStorage();

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // ── 키 상수 ──────────────────────────────────────
  static const String _keyAccessToken = 'guda_access_token';
  static const String _keyRefreshToken = 'guda_refresh_token';
  static const String _keyUserId = 'guda_user_id';
  static const String _keyThemeMode = 'guda_theme_mode';

  // ── 인증 토큰 ─────────────────────────────────────

  /// 액세스 토큰 저장
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _keyAccessToken, value: token);
  }

  /// 액세스 토큰 조회
  Future<String?> getAccessToken() async {
    return _storage.read(key: _keyAccessToken);
  }

  /// 리프레시 토큰 저장
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _keyRefreshToken, value: token);
  }

  /// 리프레시 토큰 조회
  Future<String?> getRefreshToken() async {
    return _storage.read(key: _keyRefreshToken);
  }

  /// 사용자 ID 저장
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _keyUserId, value: userId);
  }

  /// 사용자 ID 조회
  Future<String?> getUserId() async {
    return _storage.read(key: _keyUserId);
  }

  // ── 앱 설정 ──────────────────────────────────────

  /// 테마 모드 저장 ('light' | 'dark' | 'system')
  Future<void> saveThemeMode(String mode) async {
    await _storage.write(key: _keyThemeMode, value: mode);
  }

  /// 테마 모드 조회
  Future<String?> getThemeMode() async {
    return _storage.read(key: _keyThemeMode);
  }

  // ── 초기화 ────────────────────────────────────────

  /// 로그아웃 시 인증 관련 데이터 전체 초기화
  Future<void> clearAuthData() async {
    await Future.wait([
      _storage.delete(key: _keyAccessToken),
      _storage.delete(key: _keyRefreshToken),
      _storage.delete(key: _keyUserId),
    ]);
  }

  /// 스토리지 전체 초기화 (앱 초기화, 탈퇴 등)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
