import 'package:guda_chatbot/features/bookmarks/domain/entities/bookmark.dart';
import 'package:guda_chatbot/features/bookmarks/domain/repositories/bookmark_repository.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final List<Bookmark> _bookmarks = [];

  @override
  Future<List<Bookmark>> getBookmarks() async {
    // 시뮬레이션을 위한 지연 시간
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_bookmarks);
  }

  @override
  Future<void> addBookmark(Bookmark bookmark) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _bookmarks.add(bookmark);
  }

  @override
  Future<void> removeBookmark(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _bookmarks.removeWhere((b) => b.id == id);
  }
}
