import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/chat_usage_log.dart';

part 'chat_usage_log_dto.freezed.dart';
part 'chat_usage_log_dto.g.dart';

@freezed
abstract class ChatUsageLogDto with _$ChatUsageLogDto {
  const factory ChatUsageLogDto({
    required int id,
    required String action,
    required int amount,
    required int remaining,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'chat_room_title') String? chatRoomTitle,
  }) = _ChatUsageLogDto;

  factory ChatUsageLogDto.fromJson(Map<String, dynamic> json) =>
      _$ChatUsageLogDtoFromJson(json);

  const ChatUsageLogDto._();

  ChatUsageLog toDomain() => ChatUsageLog(
        id: id,
        action: action,
        amount: amount,
        remaining: remaining,
        createdAt: DateTime.parse(createdAt),
        chatRoomTitle: chatRoomTitle,
      );
}
