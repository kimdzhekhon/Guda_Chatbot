import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_scaffold.dart';
import 'package:guda_chatbot/features/bookmarks/presentation/viewmodels/bookmark_providers.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_app_bar.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_loading_widget.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_error_widget.dart';

import 'package:guda_chatbot/features/bookmarks/presentation/widgets/bookmark_list.dart';

class BookmarkScreen extends ConsumerWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksProvider);

    return GudaScaffold(
      appBar: const GudaAppBar(
        title: '보관함',
      ),
      body: bookmarksAsync.when(
        data: (bookmarks) => BookmarkList(bookmarks: bookmarks),
        loading: () => const GudaLoadingWidget(),
        error: (e, st) => GudaErrorWidget(
          message: '${AppStrings.errorPrefix} $e',
          onRetry: () => ref.refresh(bookmarksProvider),
        ),
      ),
    );
  }
}
