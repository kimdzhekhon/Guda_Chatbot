import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/network/share_service.dart';
import 'package:guda_chatbot/features/bookmarks/domain/entities/bookmark.dart';
import 'package:guda_chatbot/features/bookmarks/presentation/viewmodels/bookmark_providers.dart';
import 'package:guda_chatbot/features/chat/domain/entities/message.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/result_card.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_button.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:uuid/uuid.dart';

/// 채팅 메시지 하단의 액션 버튼(북마크, 공유) 위젯
class GudaMessageActions extends ConsumerWidget {
  const GudaMessageActions({
    super.key,
    required this.message,
    required this.isDark,
    required this.shareKey,
  });

  final Message message;
  final bool isDark;
  final GlobalKey shareKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksProvider);
    final isBookmarked =
        bookmarksAsync.value?.any((b) => b.referenceId == message.id) ?? false;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 북마크 버튼
        IconButton(
          icon: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            size: 18,
            color: isBookmarked
                ? GudaColors.accent
                : (isDark ? Colors.white54 : Colors.black45),
          ),
          onPressed: () {
            if (isBookmarked) {
              ref
                  .read(bookmarksProvider.notifier)
                  .removeBookmarkByReferenceId(message.id);
            } else {
              ref.read(bookmarksProvider.notifier).addBookmark(
                    Bookmark(
                      id: const Uuid().v4(),
                      userId: 'user-1',
                      title: message.content.length > 20
                          ? '${message.content.substring(0, 20)}...'
                          : message.content,
                      content: message.content,
                      type: BookmarkType.message,
                      referenceId: message.id,
                      createdAt: DateTime.now(),
                    ),
                  );
            }
          },
        ),
        // 공유 버튼
        IconButton(
          icon: Icon(
            Icons.share_outlined,
            size: 18,
            color: isDark ? Colors.white54 : Colors.black45,
          ),
          onPressed: () => _showShareDialog(context),
        ),
      ],
    );
  }

  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RepaintBoundary(
                key: shareKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GudaSpacing.md,
                    vertical: GudaSpacing.sm,
                  ),
                  child: ResultCard(
                    title: AppStrings.aiAdviceTitle,
                    content: message.content,
                    isDark: isDark,
                  ),
                ),
              ),
              const SizedBox(height: GudaSpacing.md),
              GudaButton.filled(
                onPressed: () {
                  ShareService.shareWidgetAsImage(
                    boundaryKey: shareKey,
                    fileName: 'guda_result_${message.id}',
                    text: AppStrings.aiAdviceMsg,
                  );
                  Navigator.pop(context);
                },
                icon: Icons.share,
                label: AppStrings.shareAsImage,
                backgroundColor: Colors.white,
                foregroundColor: GudaColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
