import 'package:freezed_annotation/freezed_annotation.dart';

part 'persona.freezed.dart';

/// 페르소나 도메인 엔티티
@freezed
abstract class Persona with _$Persona {
  const factory Persona({
    /// 식별자 (wise, friendly, strict 등)
    required String id,

    /// 페르소나 이름
    required String name,

    /// 페르소나 설명
    required String description,

    /// AI 시스템 프롬프트에 결합될 추가 지침
    required String addedPrompt,

    /// 아이콘 또는 이미지 경로 (필요 시)
    String? iconPath,
  }) = _Persona;
}
