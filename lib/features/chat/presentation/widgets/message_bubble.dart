import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_message_item.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_markdown.dart';
import 'package:guda_chatbot/features/chat/domain/entities/message.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/features/bookmarks/domain/entities/bookmark.dart';
import 'package:guda_chatbot/features/bookmarks/presentation/viewmodels/bookmark_providers.dart';
import 'package:guda_chatbot/core/network/share_service.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/result_card.dart';
import 'package:guda_chatbot/core/constants/app_assets.dart';
import 'package:uuid/uuid.dart';

class MessageBubble extends ConsumerWidget {
  MessageBubble({
    super.key,
    required this.message,
    required this.isDark,
    this.showActions = true,
  });

  final Message message;
  final bool isDark;
  final bool showActions;
  final GlobalKey _shareKey = GlobalKey();

  bool get isUser => message.role == MessageRole.user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksProvider);
    final isBookmarked = bookmarksAsync.value?.any((b) => b.referenceId == message.id) ?? false;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUser) ...[
          Padding(
            padding: const EdgeInsets.only(top: GudaSpacing.sm, left: GudaSpacing.md),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: isDark ? GudaColors.surfaceDark : GudaColors.surfaceLight,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset(AppAssets.appLogoTransparent),
              ),
            ),
          ),
        ],
        Flexible(
          child: Column(
            crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              GudaMessageItem(
                isUser: isUser,
                isDark: isDark,
                isStreaming: message.isStreaming,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isUser)
                      Text(
                        message.content,
                        style: GudaTypography.body1(color: GudaColors.onUserBubble),
                      )
                    else
                      GudaMarkdown(
                        data: message.content,
                        isDark: isDark,
                      ),
                    if (!isUser && !message.isStreaming && showActions) ...[
                      const SizedBox(height: GudaSpacing.sm),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                              size: 18,
                              color: isBookmarked ? GudaColors.accent : (isDark ? Colors.white54 : Colors.black45),
                            ),
                            onPressed: () {
                              if (isBookmarked) {
                                ref.read(bookmarksProvider.notifier).removeBookmarkByReferenceId(message.id);
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
                          IconButton(
                            icon: Icon(
                              Icons.share_outlined,
                              size: 18,
                              color: isDark ? Colors.white54 : Colors.black45,
                            ),
                            onPressed: () async {
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
                                          key: _shareKey,
                                          child: ResultCard(
                                            title: 'Guda AI의 조언',
                                            content: message.content,
                                            isDark: isDark,
                                          ),
                                        ),
                                        const SizedBox(height: GudaSpacing.md),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            ShareService.shareWidgetAsImage(
                                              boundaryKey: _shareKey,
                                              fileName: 'guda_result_${message.id}',
                                              text: 'Guda AI가 전하는 지혜입니다.',
                                            );
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(Icons.share),
                                          label: const Text('이미지로 공유하기'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: GudaColors.primary,
                                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(GudaRadius.full),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
