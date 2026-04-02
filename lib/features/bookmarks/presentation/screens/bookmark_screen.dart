import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_scaffold.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_app_bar.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_async_body.dart';
import 'package:guda_chatbot/features/bookmarks/domain/entities/bookmark.dart';
import 'package:guda_chatbot/features/bookmarks/presentation/viewmodels/bookmark_providers.dart';
import 'package:guda_chatbot/features/bookmarks/presentation/widgets/bookmark_list.dart';

class BookmarkScreen extends ConsumerWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GudaScaffold(
      appBar: const GudaAppBar(title: '보관함'),
      body: GudaAsyncBody<List<Bookmark>>(
        asyncValue: ref.watch(bookmarksProvider),
        onRetry: () => ref.refresh(bookmarksProvider),
        errorMessage: '보관함을 불러오지 못했습니다.',
        builder: (bookmarks) => BookmarkList(bookmarks: bookmarks),
      ),
    );
  }
}
