/// 날짜 관련 확장 함수 (라이브러리 사용 최소화를 위함)
extension GudaDateExtension on DateTime {
  /// 'MM.dd' 형식으로 변환 (예: 03.24)
  String toMmDd() {
    final monthStr = month.toString().padLeft(2, '0');
    final dayStr = day.toString().padLeft(2, '0');
    return '$monthStr.$dayStr';
  }

  /// 'HH:mm' 형식으로 변환 (예: 14:05)
  String toHhMm() {
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }

  /// 'yyyy.MM.dd' 형식으로 변환 (예: 2024.03.24)
  String toYyyyMmDd() {
    final yearStr = year.toString();
    final monthStr = month.toString().padLeft(2, '0');
    final dayStr = day.toString().padLeft(2, '0');
    return '$yearStr.$monthStr.$dayStr';
  }
}
