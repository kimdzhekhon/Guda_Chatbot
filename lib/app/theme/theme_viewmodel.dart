import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/security/storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_viewmodel.g.dart';

/// ThemeViewModel — 앱 테마 모드 관리 (System, Light, Dark)
@riverpod
class ThemeViewModel extends _$ThemeViewModel {
  @override
  FutureOr<ThemeMode> build() async {
    final storage = ref.watch(storageServiceProvider);
    final modeStr = await storage.getThemeMode();
    return _mapStringToThemeMode(modeStr);
  }

  /// 테마 모드 변경 및 저장
  Future<void> setThemeMode(ThemeMode mode) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final storage = ref.read(storageServiceProvider);
      await storage.setThemeMode(mode.name);
      return mode;
    });
  }

  ThemeMode _mapStringToThemeMode(String mode) {
    return ThemeMode.values.firstWhere(
      (e) => e.name == mode,
      orElse: () => ThemeMode.system,
    );
  }
}
