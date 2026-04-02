import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';
import 'package:guda_chatbot/core/utils/date_extensions.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_scaffold.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_app_bar.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_tile.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_divider.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_empty_state.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_loading_widget.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_error_widget.dart';
import 'package:guda_chatbot/features/payment/presentation/viewmodels/purchase_history_viewmodel.dart';

class PurchaseHistoryScreen extends ConsumerWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(purchaseHistoryViewModelProvider);

    return GudaScaffold(
      appBar: const GudaAppBar(title: '구매 내역'),
      body: historyAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return const GudaEmptyState(
              title: '구매 내역이 없습니다.',
              subtitle: '아직 구매하신 내역이 없습니다.\n다양한 플랜을 확인해 보세요.',
              icon: Icons.receipt_long_rounded,
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(purchaseHistoryViewModelProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: GudaSpacing.md),
              itemCount: logs.length,
              separatorBuilder: (context, index) => const GudaDivider(alpha: 0.5),
              itemBuilder: (context, index) {
                final log = logs[index];
                return GudaTile(
                  title: log.productName,
                  subtitle: log.createdAt.toYyyyMmDd(),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${log.amount}원',
                        style: GudaTypography.body1Bold(
                          color: context.colorScheme.primary,
                        ),
                      ),
                      Text(
                        log.isSuccess ? '결제완료' : '결제취소/실패',
                        style: GudaTypography.caption(
                          color: log.isSuccess 
                              ? context.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)
                              : context.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: GudaLoadingWidget()),
        error: (error, stack) => GudaErrorWidget(
          message: '구매 내역을 불러오지 못했습니다.',
          onRetry: () => ref.read(purchaseHistoryViewModelProvider.notifier).refresh(),
        ),
      ),
    );
  }
}
