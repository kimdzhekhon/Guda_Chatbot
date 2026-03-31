import 'package:freezed_annotation/freezed_annotation.dart';

/// 페르소나 종류를 정의하는 Enum
enum PersonaType {
  /// 지혜로운 현자 (Default)
  @JsonValue('wise')
  wise,

  /// 따뜻한 친구 (Friendly)
  @JsonValue('friendly')
  friendly,

  /// 냉철한 분석가 (Strict)
  @JsonValue('strict')
  strict;

  /// 문자열을 PersonaType으로 변환
  static PersonaType fromString(String? value) {
    return PersonaType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PersonaType.wise,
    );
  }
}
