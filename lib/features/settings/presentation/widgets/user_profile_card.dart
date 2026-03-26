import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_lottie.dart';
import 'package:guda_chatbot/core/constants/app_assets.dart';
import 'package:guda_chatbot/features/auth/domain/entities/guda_user.dart';
import 'package:guda_chatbot/features/chat/domain/entities/chat_usage.dart';
import 'package:guda_chatbot/features/settings/presentation/widgets/user_usage_stats.dart';

/// 사용자의 프로필, 플랜 정보, 사용량을 표시하는 카드 위젯
class UserProfileCard extends StatelessWidget {
  const UserProfileCard({
    super.key,
    required this.user,
    required this.usage,
    required this.progress,
  });

  final GudaUser user;
  final ChatUsage usage;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(GudaSpacing.lg),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: GudaRadius.lgAll,
        boxShadow: GudaShadows.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GudaLottie(
            path: AppAssets.lotusLottie,
            size: 60,
          ),
          const SizedBox(width: GudaSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 플랜 배지
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GudaSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: GudaRadius.smAll,
                  ),
                  child: Text(
                    usage.planName,
                    style: GudaTypography.captionBold(color: context.colorScheme.primary),
                  ),
                ),
                const SizedBox(height: GudaSpacing.xs),
                // 이메일
                Text(
                  user.email,
                  style: GudaTypography.heading3(color: context.colorScheme.onSurface),
                ),
                const SizedBox(height: GudaSpacing.md),
                UserUsageStats(
                  label: '대화 사용량',
                  progress: progress,
                  remainingText: '${usage.usedCount} / ${usage.totalLimit}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
