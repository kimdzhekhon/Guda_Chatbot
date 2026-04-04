import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/constants/app_assets.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_bookmark_tile.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_empty_state.dart';
import 'package:guda_chatbot/features/bookmarks/domain/entities/bookmark.dart';
import 'package:guda_chatbot/features/bookmarks/presentation/viewmodels/bookmark_providers.dart';

import 'package:go_router/go_router.dart';
import 'package:guda_chatbot/app/router/route_paths.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/home_viewmodel.dart';

// 매 빌드마다 Regex를 생성하지 않도록 static 캐싱
final _headingContentRegex = RegExp(r'^#+ ', multiLine: true);
final _headingTitleRegex = RegExp(r'^#+ ');

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
            .replaceAll(_headingContentRegex, '')
            .trim();
        final cleanTitle = bookmark.title.replaceAll(_headingTitleRegex, '');
        final d = bookmark.createdAt;
        final formattedDate = '${d.year}.${d.month}.${d.day}';

        return GudaBookmarkTile(
          key: ValueKey(bookmark.id),
          title: cleanTitle,
          content: cleanContent,
          date: formattedDate,
          onTap: () {
            if (bookmark.chatRoomId != null && bookmark.topicCode != null) {
              ref
                  .read(homeViewModelProvider.notifier)
                  .selectChatRoomById(bookmark.chatRoomId!, bookmark.topicCode!);
              context.go(RoutePaths.chatList);
            }
          },
          onDelete: () {
            ref.read(bookmarksProvider.notifier).removeBookmark(bookmark.id);
          },
        );
      },
    );
  }
}
