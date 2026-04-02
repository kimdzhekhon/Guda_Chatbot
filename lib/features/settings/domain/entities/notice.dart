/// 공지사항 엔티티 — system_config 테이블의 공지 데이터
class Notice {
  const Notice({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
    this.isActive = true,
  });

  final int id;
  final String title;
  final String content;
  final DateTime updatedAt;
  final bool isActive;

  factory Notice.fromSystemConfig(Map<String, dynamic> row) {
    final updatedAtStr = row['updated_at'] as String? ?? DateTime.now().toIso8601String();

    return Notice(
      id: row['id'] as int? ?? 0,
      title: row['notice_title'] as String? ?? '제목 없음',
      content: row['notice_content'] as String? ?? '',
      isActive: true, // 특정 활성화 여부가 필요하다면 칼럼을 추가해야 하지만, 현재는 조회된 모든 공지를 활성으로 간주
      updatedAt: DateTime.tryParse(updatedAtStr) ?? DateTime.now(),
    );
  }
}
