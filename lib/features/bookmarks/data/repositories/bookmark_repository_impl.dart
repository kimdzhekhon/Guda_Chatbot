import 'package:guda_chatbot/features/bookmarks/domain/entities/bookmark.dart';
import 'package:guda_chatbot/features/bookmarks/domain/repositories/bookmark_repository.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/core/network/rpc_invoker.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  BookmarkRepositoryImpl(this._rpcInvoker);

  final RpcInvoker _rpcInvoker;

  @override
  Future<List<Bookmark>> getBookmarks() async {
    return _rpcInvoker.invokeList(
      functionName: 'get_bookmarks',
      fromJson: _fromJson,
    );
  }

  @override
  Future<void> addBookmark(Bookmark bookmark) async {
    await _rpcInvoker.invoke(
      functionName: 'add_bookmark',
      params: {
        'p_title': bookmark.title,
        'p_content': bookmark.content,
        'p_type': bookmark.type.name,
        'p_reference_id': bookmark.referenceId,
        'p_chat_room_id': bookmark.chatRoomId,
        'p_topic_code': bookmark.topicCode?.name,
      },
      fromJson: _fromJson,
    );
  }

  @override
  Future<void> removeBookmark(String id) async {
    await _rpcInvoker.invokeVoid(
      functionName: 'remove_bookmark',
      params: {'p_bookmark_id': id},
    );
  }

  static Bookmark _fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      type: BookmarkType.values.byName(json['type'] as String),
      referenceId: json['reference_id'] as String,
      chatRoomId: json['chat_room_id'] as String?,
      topicCode: json['topic_code'] != null
          ? ClassicType.values.byName(json['topic_code'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
