import 'package:guda_chatbot/features/bookmarks/domain/entities/bookmark.dart';

abstract interface class BookmarkRepository {
  Future<List<Bookmark>> getBookmarks();
  Future<void> addBookmark(Bookmark bookmark);
  Future<void> removeBookmark(String id);
}
