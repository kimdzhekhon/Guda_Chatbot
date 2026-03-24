/// 주역 64괘 엔티티
class Hexagram {
  /// 괘 번호 (1-64)
  final int id;

  /// 한글 이름
  final String name;

  /// 한문 이름
  final String hanja;

  /// 6효(爻)의 상태 (이진수 문자열, 예: "111111" = 건괘)
  /// 1: 양(陽) — 끊어지지 않은 선
  /// 0: 음(陰) — 가운데가 끊어진 선
  /// 밑에서부터 첫 번째 효가 문자열의 첫 번째 문자
  final String binary;

  /// 풀이 요약
  final String summary;

  const Hexagram({
    required this.id,
    required this.name,
    required this.hanja,
    required this.binary,
    required this.summary,
  });

  /// 각 효의 리스트 반환 (밑에서부터)
  List<int> get lines => binary.split('').map(int.parse).toList();
}
