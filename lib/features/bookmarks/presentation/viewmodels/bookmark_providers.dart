import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:guda_chatbot/features/bookmarks/domain/entities/bookmark.dart';
import 'package:guda_chatbot/features/bookmarks/domain/repositories/bookmark_repository.dart';
import 'package:guda_chatbot/features/bookmarks/data/repositories/bookmark_repository_impl.dart';

part 'bookmark_providers.g.dart';

@riverpod
BookmarkRepository bookmarkRepository(Ref ref) {
  return BookmarkRepositoryImpl();
}

@riverpod
class BookmarksNotifier extends _$BookmarksNotifier {
  @override
  Future<List<Bookmark>> build() {
    return ref.watch(bookmarkRepositoryProvider).getBookmarks();
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(bookmarkRepositoryProvider).addBookmark(bookmark);
      await _refreshBookmarks();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> removeBookmark(String id) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(bookmarkRepositoryProvider).removeBookmark(id);
      await _refreshBookmarks();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> _refreshBookmarks() async {
    final newList = await ref.read(bookmarkRepositoryProvider).getBookmarks();
    state = AsyncValue.data(newList);
  }

  Future<void> removeBookmarkByReferenceId(String referenceId) async {
    final bookmark = state.value?.firstWhere((b) => b.referenceId == referenceId);
    if (bookmark != null) {
      await removeBookmark(bookmark.id);
    }
  }

  bool isBookmarked(String referenceId) {
    return state.value?.any((b) => b.referenceId == referenceId) ?? false;
  }
}
