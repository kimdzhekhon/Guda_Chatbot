import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_app_bar.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_scaffold.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_divider.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_loading_widget.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_error_widget.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_empty_state.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/features/settings/domain/entities/notice.dart';
import 'package:guda_chatbot/features/settings/presentation/viewmodels/notice_viewmodel.dart';

/// SCR_NOTICE — 공지사항 화면
class NoticeScreen extends ConsumerWidget {
  const NoticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noticeState = ref.watch(noticeProvider);

    return GudaScaffold(
      appBar: const GudaAppBar(title: '공지사항'),
      body: switch (noticeState) {
        UiLoading() => const GudaLoadingWidget(),
        UiSuccess(data: final notices) => notices.isEmpty
            ? const GudaEmptyState(
                title: '공지사항이 없습니다.',
                icon: Icons.notifications_none_rounded,
              )
            : _NoticeList(notices: notices),
        UiError() => GudaErrorWidget(
            message: '공지사항을 불러올 수 없습니다.',
            onRetry: () => ref.read(noticeProvider.notifier).refresh(),
          ),
      },
    );
  }
}

class _NoticeList extends StatelessWidget {
  const _NoticeList({required this.notices});

  final List<Notice> notices;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: GudaSpacing.md),
      itemCount: notices.length,
      separatorBuilder: (_, _) => const GudaDivider(),
      itemBuilder: (context, index) => _NoticeItem(notice: notices[index]),
    );
  }
}

class _NoticeItem extends StatefulWidget {
  const _NoticeItem({required this.notice});

  final Notice notice;

  @override
  State<_NoticeItem> createState() => _NoticeItemState();
}

class _NoticeItemState extends State<_NoticeItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.notice.updatedAt;
    final dateStr = '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';

    return InkWell(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: GudaSpacing.xl,
          vertical: GudaSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.notice.title,
                    style: GudaTypography.body2Bold(
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: context.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.5),
                ),
              ],
            ),
            const SizedBox(height: GudaSpacing.xs),
            Text(
              dateStr,
              style: GudaTypography.caption(
                color: context.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.5),
              ),
            ),
            if (_isExpanded) ...[
              const SizedBox(height: GudaSpacing.md),
              Text(
                widget.notice.content,
                style: GudaTypography.body2(
                  color: context.colorScheme.onSurface
                      .withValues(alpha: 0.85),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
