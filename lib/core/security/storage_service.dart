import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_service.g.dart';

/// StorageService — 보안 저장소 관리 (FlutterSecureStorage)
/// 설정값, 토큰 등 민감 정보를 관리합니다.
class StorageService {
  final FlutterSecureStorage _storage;

  StorageService(this._storage);

  static const String _fontScaleKey = 'font_scale';
  static const String _themeModeKey = 'theme_mode';

  /// 폰트 배율 저장
  Future<void> setFontScale(double scale) async {
    await _storage.write(key: _fontScaleKey, value: scale.toString());
  }

  /// 폰트 배율 불러오기 (기본값 1.0)
  Future<double> getFontScale() async {
    final value = await _storage.read(key: _fontScaleKey);
    return value != null ? double.parse(value) : 1.0;
  }

  /// 테마 모드 저장
  Future<void> setThemeMode(String mode) async {
    await _storage.write(key: _themeModeKey, value: mode);
  }

  /// 테마 모드 불러오기 (기본값 'system')
  Future<String> getThemeMode() async {
    final value = await _storage.read(key: _themeModeKey);
    return value ?? 'system';
  }
}

@riverpod
StorageService storageService(Ref ref) {
  return StorageService(const FlutterSecureStorage());
}
