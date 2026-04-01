import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';

part 'bookmark.freezed.dart';
part 'bookmark.g.dart';

enum BookmarkType {
  message,
  hexagram,
}

@freezed
abstract class Bookmark with _$Bookmark {
  const factory Bookmark({
    required String id,
    required String userId,
    required String title,
    required String content,
    required BookmarkType type,
    required String referenceId,
    String? chatRoomId,
    ClassicType? topicCode,
    required DateTime createdAt,
  }) = _Bookmark;

  factory Bookmark.fromJson(Map<String, dynamic> json) => _$BookmarkFromJson(json);
}
