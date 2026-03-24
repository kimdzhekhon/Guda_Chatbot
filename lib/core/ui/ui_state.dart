/// `UiState<T>` — 앱 전체 화면 상태 통합 봉인 클래스 (Loading / Success / Error)
/// 모든 ViewModel은 반드시 이 클래스를 통해 상태를 관리해야 함
sealed class UiState<T> {
  const UiState();
}

/// 로딩 중 상태
final class UiLoading<T> extends UiState<T> {
  const UiLoading();
}

/// 성공 상태 — 데이터 포함
final class UiSuccess<T> extends UiState<T> {
  const UiSuccess(this.data);
  final T data;
}

/// 오류 상태 — 메시지 및 선택적 에러 코드 포함
final class UiError<T> extends UiState<T> {
  const UiError(this.message, {this.errorCode});
  final String message;
  final String? errorCode;
}

/// UiState 확장 메서드 — 상태 분기 처리 편의성
extension UiStateExtension<T> on UiState<T> {
  /// 로딩 상태인지 확인
  bool get isLoading => this is UiLoading<T>;

  /// 성공 상태인지 확인
  bool get isSuccess => this is UiSuccess<T>;

  /// 오류 상태인지 확인
  bool get isError => this is UiError<T>;

  /// 성공 시 데이터 반환, 아니면 null
  T? get dataOrNull => switch (this) {
    UiSuccess<T>(data: final d) => d,
    _ => null,
  };

  /// 오류 시 메시지 반환, 아니면 null
  String? get errorOrNull => switch (this) {
    UiError<T>(message: final m) => m,
    _ => null,
  };

  /// 상태별 위젯 반환 헬퍼
  R when<R>({
    required R Function() loading,
    required R Function(T data) success,
    required R Function(String message, String? errorCode) error,
  }) => switch (this) {
    UiLoading<T>() => loading(),
    UiSuccess<T>(data: final d) => success(d),
    UiError<T>(message: final m, errorCode: final c) => error(m, c),
  };
}
