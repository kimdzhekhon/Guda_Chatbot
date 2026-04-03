import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/features/bookmarks/domain/entities/bookmark.dart';
import 'package:guda_chatbot/features/bookmarks/presentation/viewmodels/bookmark_providers.dart';
import 'package:guda_chatbot/features/chat/domain/entities/message.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';
import 'package:uuid/uuid.dart';

import 'package:guda_chatbot/features/chat/presentation/widgets/share_preview_dialog.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/home_viewmodel.dart';

/// 채팅 메시지 하단의 액션 버튼(북마크, 공유) 위젯
class GudaMessageActions extends ConsumerWidget {
  const GudaMessageActions({
    super.key,
    required this.message,
    required this.shareKey,
  });

  final Message message;
  final GlobalKey shareKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarked = ref.watch(bookmarksProvider.select(
      (state) => state.value?.any((b) => b.referenceId == message.id.toString()) ?? false,
    ));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            size: 18,
            color: isBookmarked
                ? GudaColors.accent
                : context.onSurfaceVariantColor.withValues(alpha: 0.5),
          ),
          onPressed: () {
            if (isBookmarked) {
              ref
                  .read(bookmarksProvider.notifier)
                  .removeBookmarkByReferenceId(message.id.toString());
            } else {
              final topicCode = ref.read(homeViewModelProvider.select((s) => s.selectedClassicType));
              ref.read(bookmarksProvider.notifier).addBookmark(
                    Bookmark(
                      id: const Uuid().v4(),
                      userId: 'user-1',
                      title: message.content.length > 20
                          ? '${message.content.substring(0, 20)}...'
                          : message.content,
                      content: message.content,
                      type: BookmarkType.message,
                      referenceId: message.id.toString(),
                      chatRoomId: message.chatRoomId,
                      topicCode: topicCode,
                      createdAt: DateTime.now(),
                    ),
                  );
            }
          },
        ),
        IconButton(
          icon: Icon(
            Icons.share_outlined,
            size: 18,
            color: context.onSurfaceVariantColor.withValues(alpha: 0.5),
          ),
          onPressed: () => _showShareDialog(context),
        ),
      ],
    );
  }

  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SharePreviewDialog(
        message: message,
        shareKey: shareKey,
      ),
    );
  }
}
