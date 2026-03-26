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

  String _typeIcon(ClassicType type) => switch (type) {
        ClassicType.tripitaka => AppAssets.tripitakaImage,
        ClassicType.iching => AppAssets.ichingImage,
      };

  @override
  Widget build(BuildContext context) {
    return GudaTile(
      onTap: onTap,
      isSelected: isActive,
      leading: ClipRRect(
        borderRadius: GudaRadius.smAll,
        child: Image.asset(
          _typeIcon(conversation.classicType),
          width: 28,
          height: 28,
          fit: BoxFit.cover,
        ),
      ),
      title: conversation.title,
      subtitle: conversation.updatedAt.toLocal().toMmDd(),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline_rounded, size: 16),
        onPressed: onDelete,
        color: context.onSurfaceVariantColor.withValues(alpha: 0.4),
      ),
    );
  }
}
