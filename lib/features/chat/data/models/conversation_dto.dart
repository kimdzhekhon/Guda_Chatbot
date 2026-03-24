import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/domain/entities/conversation.dart';

part 'conversation_dto.freezed.dart';
part 'conversation_dto.g.dart';

/// 대화 세션 DTO — Supabase 응답을 도메인 엔티티로 변환
@freezed
abstract class ConversationDto with _$ConversationDto {
  const factory ConversationDto({
    required String id,
    required String title,
    @JsonKey(name: 'classic_type') required String classicType,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'last_message_preview') String? lastMessagePreview,
    @JsonKey(name: 'message_count') @Default(0) int messageCount,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _ConversationDto;

  factory ConversationDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationDtoFromJson(json);

  const ConversationDto._();

  Conversation toDomain() => Conversation(
    id: id,
    title: title,
    classicType: ClassicType.values.firstWhere((e) => e.name == classicType),
    userId: userId,
    lastMessagePreview: lastMessagePreview,
    messageCount: messageCount,
    createdAt: DateTime.parse(createdAt),
    updatedAt: DateTime.parse(updatedAt),
  );
}
