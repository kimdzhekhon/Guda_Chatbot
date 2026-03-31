import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';

part 'conversation.freezed.dart';

/// 대화 세션 엔티티 (도메인 레이어)
@freezed
abstract class Conversation with _$Conversation {
  const factory Conversation({
    /// Supabase 대화 UUID
    required String id,

    /// 대화 제목 (첫 메시지 기반 자동 생성)
    required String title,

    /// 주제 코드 (고전 유형)
    required ClassicType topicCode,

    /// 소유자 사용자 ID
    required String userId,

    /// 페르소나 ID
    String? personaId,

    /// 마지막 메시지 미리보기
    String? lastMessagePreview,

    /// 메시지 총 개수
    @Default(0) int messageCount,

    /// 생성 일시
    required DateTime createdAt,

    /// 최종 메시지 일시
    required DateTime lastMessageAt,
  }) = _Conversation;
}
