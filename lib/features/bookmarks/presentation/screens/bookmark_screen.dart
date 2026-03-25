import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/layout/app_responsive_layout.dart';
import 'package:guda_chatbot/features/bookmarks/domain/entities/bookmark.dart';
import 'package:guda_chatbot/features/bookmarks/presentation/viewmodels/bookmark_providers.dart';
import 'package:guda_chatbot/core/constants/app_assets.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_app_bar.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_empty_state.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_loading_widget.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_error_widget.dart';

class BookmarkScreen extends ConsumerWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const GudaAppBar(
        title: '보관함',
      ),
      body: AppResponsiveLayout(
        useSafeArea: false,
        mobile: (context, data) => _buildBookmarkList(bookmarksAsync, isDark, ref),
        tablet: (context, data) => Center(
          child: SizedBox(
            width: 600,
            child: _buildBookmarkList(bookmarksAsync, isDark, ref),
          ),
        ),
        desktop: (context, data) => Center(
          child: SizedBox(
            width: 800,
            child: _buildBookmarkList(bookmarksAsync, isDark, ref),
          ),
        ),
      ),
    );
  }

  Widget _buildBookmarkList(AsyncValue<List<Bookmark>> bookmarksAsync, bool isDark, WidgetRef ref) {
    return bookmarksAsync.when(
      data: (bookmarks) {
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
            
            return Container(
              decoration: BoxDecoration(
                color: isDark ? GudaColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(GudaRadius.md),
                boxShadow: GudaShadows.card,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(GudaRadius.md),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 6,
                        color: GudaColors.primary,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(GudaSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      bookmark.title.replaceAll(RegExp(r'^#+ '), ''),
                                      style: GudaTypography.body1Bold(
                                        color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: GudaColors.error, size: 20),
                                    onPressed: () {
                                      ref.read(bookmarksProvider.notifier).removeBookmark(bookmark.id);
                                    },
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                  ),
                                ],
                              ),
                              const SizedBox(height: GudaSpacing.xs),
                              Text(
                                cleanContent,
                                style: GudaTypography.body2(
                                  color: isDark ? GudaColors.onSurfaceVariantDark : GudaColors.onSurfaceVariantLight,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: GudaSpacing.sm),
                              Text(
                                '${bookmark.createdAt.year}.${bookmark.createdAt.month}.${bookmark.createdAt.day}',
                                style: GudaTypography.caption2(
                                  color: isDark ? Colors.white38 : Colors.black38,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const GudaLoadingWidget(),
      error: (e, st) => GudaErrorWidget(
        message: '${AppStrings.errorPrefix} $e',
        onRetry: () => ref.refresh(bookmarksProvider),
      ),
    );
  }
}

// Fixed typo in mainAxisAlignment
extension on BookmarkScreen {
}
