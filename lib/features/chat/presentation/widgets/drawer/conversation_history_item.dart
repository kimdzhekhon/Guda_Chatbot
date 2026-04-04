import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/constants/app_assets.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_tile.dart';
import 'package:guda_chatbot/core/utils/date_extensions.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';
import 'package:guda_chatbot/features/chat/domain/entities/classic_type.dart';
import 'package:guda_chatbot/features/chat/domain/entities/conversation.dart';

class ConversationHistoryItem extends StatelessWidget {
  const ConversationHistoryItem({
    super.key,
    required this.conversation,
    required this.isActive,
    required this.onTap,
    required this.onDelete,
  });

  final Conversation conversation;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  // 타입별 아이콘을 static const Map으로 캐싱 (build마다 switch 평가 방지)
  static const _typeIcons = {
    ClassicType.tripitaka: AppAssets.tripitakaImage,
    ClassicType.iching: AppAssets.ichingImage,
  };

  @override
  Widget build(BuildContext context) {
    return GudaTile(
      onTap: onTap,
      isSelected: isActive,
      leading: ClipRRect(
        borderRadius: GudaRadius.smAll,
        child: Image.asset(
          _typeIcons[conversation.topicCode]!,
          width: 28,
          height: 28,
          fit: BoxFit.cover,
          // 이미지 프레임 캐시를 유지하여 스크롤 시 디코딩 반복 방지
          cacheWidth: 56, // 28 * 2 (device pixel ratio 2x)
        ),
      ),
      title: conversation.title,
      subtitle: conversation.lastMessageAt.toLocal().toMmDd(),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline_rounded, size: 16),
        onPressed: onDelete,
        color: context.onSurfaceVariantColor.withValues(alpha: 0.4),
      ),
    );
  }
}
