import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_divider.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_empty_state.dart';

/// Guda 공통 히스토리 리스트 위젯
/// RefreshIndicator + ListView.separated + 빈 상태 처리를 일관되게 제공합니다.
class GudaHistoryList<T> extends StatelessWidget {
  const GudaHistoryList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.emptyIcon,
    this.onRefresh,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final String emptyTitle;
  final String emptySubtitle;
  final IconData emptyIcon;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return GudaEmptyState(
        title: emptyTitle,
        subtitle: emptySubtitle,
        icon: emptyIcon,
      );
    }

    final listView = ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: GudaSpacing.md),
      itemCount: items.length,
      separatorBuilder: (context, index) => const GudaDivider(),
      itemBuilder: (context, index) => itemBuilder(context, items[index]),
    );

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        child: listView,
      );
    }

    return listView;
  }
}
