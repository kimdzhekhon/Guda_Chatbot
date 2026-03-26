import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/constants/app_assets.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_bookmark_tile.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_empty_state.dart';
import 'package:guda_chatbot/features/bookmarks/domain/entities/bookmark.dart';
import 'package:guda_chatbot/features/bookmarks/presentation/viewmodels/bookmark_providers.dart';

class BookmarkList extends ConsumerWidget {
  const BookmarkList({
    super.key,
    required this.bookmarks,
  });

  final List<Bookmark> bookmarks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (bookmarks.isEmpty) {
      return const GudaEmptyState(
        lottiePath: AppAssets.lotusLottie,
        title: AppStrings.noBookmarksMessage,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(GudaSpacing.md),
      itemCount: bookmarks.length,
      separatorBuilder: (context, index) => const SizedBox(height: GudaSpacing.md),
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
        final cleanContent = bookmark.content
            .replaceAll(RegExp(r'^#+ ', multiLine: true), '')
            .trim();
        final cleanTitle = bookmark.title.replaceAll(RegExp(r'^#+ '), '');
        final formattedDate =
            '${bookmark.createdAt.year}.${bookmark.createdAt.month}.${bookmark.createdAt.day}';

        return GudaBookmarkTile(
          title: cleanTitle,
          content: cleanContent,
          date: formattedDate,
          onDelete: () {
            ref.read(bookmarksProvider.notifier).removeBookmark(bookmark.id);
          },
        );
      },
    );
  }
}
