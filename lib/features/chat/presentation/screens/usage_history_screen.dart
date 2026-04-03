import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';
import 'package:guda_chatbot/core/utils/date_extensions.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_scaffold.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_app_bar.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_tile.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_async_body.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_history_list.dart';
import 'package:guda_chatbot/features/chat/domain/entities/chat_usage_log.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/usage_history_viewmodel.dart';

class UsageHistoryScreen extends ConsumerWidget {
  const UsageHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GudaScaffold(
      appBar: const GudaAppBar(title: '사용 내역'),
      body: GudaAsyncBody<List<ChatUsageLog>>(
        asyncValue: ref.watch(usageHistoryViewModelProvider),
        errorMessage: '사용 내역을 불러오지 못했습니다.',
        onRetry: () => ref.read(usageHistoryViewModelProvider.notifier).refresh(),
        builder: (logs) => GudaHistoryList<ChatUsageLog>(
          items: logs,
          emptyTitle: '사용 내역이 없습니다.',
          emptySubtitle: '아직 대화 사용 내역이 없습니다.\n구다와 함께 고민을 나누어 보세요.',
          emptyIcon: Icons.history_rounded,
          onRefresh: () => ref.read(usageHistoryViewModelProvider.notifier).refresh(),
          itemBuilder: (context, log) {
            final isDeduction = log.isDeduction;
            return GudaTile(
              title: _getActionTitle(log.action, log.chatRoomTitle),
              subtitle: '${log.createdAt.toYyyyMmDd()} ${log.createdAt.toHhMm()}',
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isDeduction ? '-' : '+'}${log.amount}',
                    style: GudaTypography.body1Bold(
                      color: isDeduction
                          ? context.colorScheme.onSurface
                          : context.colorScheme.primary,
                    ),
                  ),
                  Text(
                    '잔여 ${log.remaining}',
                    style: GudaTypography.caption(
                      color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _getActionTitle(String action, String? chatRoomTitle) {
    return switch (action) {
      'credit_used' => '대화 사용${chatRoomTitle != null ? ' ($chatRoomTitle)' : ''}',
      'credit_charged' => '대화권 충전',
      'credit_expired' => '대화권 만료',
      _ => '기타내역',
    };
  }
}
