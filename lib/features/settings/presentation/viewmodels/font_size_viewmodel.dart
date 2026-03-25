import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:guda_chatbot/core/security/storage_service.dart';

part 'font_size_viewmodel.g.dart';

/// FontSizeViewModel — 전역 글씨 크기 상태 관리
/// 3단계 슬라이더 (0.85, 1.0, 1.15)를 지원합니다.
@riverpod
class FontSizeViewModel extends _$FontSizeViewModel {
  @override
  FutureOr<double> build() async {
    final storage = ref.read(storageServiceProvider);
    return await storage.getFontScale();
  }

  /// 폰트 배율 업데이트
  Future<void> updateFontScale(double scale) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final storage = ref.read(storageServiceProvider);
      await storage.setFontScale(scale);
      return scale;
    });
  }
}
