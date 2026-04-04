import 'package:freezed_annotation/freezed_annotation.dart';

part 'hexagram.freezed.dart';

/// 주역 64괘 엔티티
@freezed
abstract class Hexagram with _$Hexagram {
  const factory Hexagram({
    /// 괘 번호 (1-64)
    required int id,

    /// 한글 이름
    required String name,

    /// 한문 이름
    required String hanja,

    /// 6효(爻)의 상태 (이진수 문자열, 예: "111111" = 건괘)
    /// 1: 양(陽) — 끊어지지 않은 선
    /// 0: 음(陰) — 가운데가 끊어진 선
    /// 밑에서부터 첫 번째 효가 문자열의 첫 번째 문자
    required String binary,

    /// 풀이 요약
    required String summary,
  }) = _Hexagram;

  const Hexagram._();

  /// 각 효의 리스트 반환 (밑에서부터)
  List<int> get lines => binary.split('').map(int.parse).toList();

  /// 그리드 표시용 축약 이름 (중/천/지 접두사 제거)
  String get shortName => name
      .replaceAll('중', '')
      .replaceAll('천', '')
      .replaceAll('지', '');
}
