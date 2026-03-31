import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_animations.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_button.dart';

/// Guda 공통 다이얼로그
class GudaDialog extends StatelessWidget {
  const GudaDialog({
    super.key,
    required this.title,
    this.content,
    this.contentWidget,
    this.confirmLabel = '확인',
    this.cancelLabel = '취소',
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
    this.showConfirm = true,
    this.showCancel = true,
  });

  final String title;
  final String? content;
  final Widget? contentWidget;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final bool showConfirm;
  final bool showCancel;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    String? content,
    Widget? contentWidget,
    String confirmLabel = '확인',
    String cancelLabel = '취소',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
    bool showConfirm = true,
    bool showCancel = true,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => GudaDialog(
        title: title,
        content: content,
        contentWidget: contentWidget,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDestructive: isDestructive,
        showConfirm: showConfirm,
        showCancel: showCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: GudaRadius.lgAll),
      backgroundColor: colorScheme.surface,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: GudaSpacing.xl),
      child: Padding(
        padding: const EdgeInsets.all(GudaSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: GudaTypography.heading3(color: colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GudaSpacing.lg),
            if (contentWidget != null || content != null) ...[
              Container(
                padding: const EdgeInsets.all(GudaSpacing.lg),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.04),
                  borderRadius: GudaRadius.mdAll,
                ),
                child: contentWidget ?? Text(
                  content!,
                  style: GudaTypography.body1(color: colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: GudaSpacing.xl),
            ],
            Row(
              children: [
                if (showCancel)
                  Expanded(
                    child: GudaButton.outlined(
                      label: cancelLabel,
                      onPressed: () {
                        onCancel?.call();
                        Navigator.pop(context, false);
                      },
                    ),
                  ),
                if (showCancel && showConfirm)
                  const SizedBox(width: GudaSpacing.md),
                if (showConfirm)
                  Expanded(
                    child: GudaButton.filled(
                      label: confirmLabel,
                      onPressed: () {
                        onConfirm?.call();
                        Navigator.pop(context, true);
                      },
                      backgroundColor: isDestructive ? colorScheme.error : colorScheme.primary,
                      foregroundColor: isDestructive ? colorScheme.onError : colorScheme.onPrimary,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    ).gudaScaleIn(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
    );
  }
}
