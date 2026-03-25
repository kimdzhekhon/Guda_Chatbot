import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/layout/app_responsive_layout.dart';
import 'package:guda_chatbot/features/bookmarks/presentation/viewmodels/bookmark_providers.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_app_bar.dart';

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
        mobile: (context, data) => bookmarksAsync.when(
          data: (bookmarks) {
            if (bookmarks.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      size: 64,
                      color: isDark ? Colors.white24 : Colors.black12,
                    ),
                    const SizedBox(height: GudaSpacing.md),
                    Text(
                      '아직 저장된 북마크가 없습니다.',
                      style: GudaTypography.body1(
                        color: isDark ? Colors.white54 : Colors.black45,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(GudaSpacing.md),
              itemCount: bookmarks.length,
              separatorBuilder: (context, index) => const SizedBox(height: GudaSpacing.md),
              itemBuilder: (context, index) {
                final bookmark = bookmarks[index];
                // Strip markdown headers from content for subtitle preview if needed
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
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('오류가 발생했습니다: $e')),
        ),
      ),
    );
  }
}

// Fixed typo in mainAxisAlignment
extension on BookmarkScreen {
}
