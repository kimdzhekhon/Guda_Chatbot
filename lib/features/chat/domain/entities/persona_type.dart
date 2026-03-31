import 'package:freezed_annotation/freezed_annotation.dart';

/// 페르소나 종류를 정의하는 Enum
enum PersonaType {
  /// 기본 (지혜로운 현자)
  @JsonValue('basic')
  basic,

  /// 친절한 (따뜻한 친구)
  @JsonValue('friendly')
  friendly,

  /// 직설적인 (냉철한 분석가)
  @JsonValue('strict')
  strict;

  /// 문자열을 PersonaType으로 변환 (JsonValue 기준)
  static PersonaType fromString(String? value) {
    if (value == null) return PersonaType.basic;
    
    return PersonaType.values.firstWhere(
      (e) => e.name == value || (e == PersonaType.basic && value == 'wise') || (e == PersonaType.strict && value == 'direct'),
      orElse: () => PersonaType.basic,
    );
  }
}
