import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_animations.dart';

/// Guda 공통 다이얼로그
class GudaDialog extends StatelessWidget {
  const GudaDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmLabel = '확인',
    this.cancelLabel = '취소',
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  });

  final String title;
  final String content;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String content,
    String confirmLabel = '확인',
    String cancelLabel = '취소',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => GudaDialog(
        title: title,
        content: content,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDestructive: isDestructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: GudaRadius.lgAll),
      backgroundColor: colorScheme.surface,
      title: Text(
        title,
        style: GudaTypography.heading3(color: colorScheme.onSurface),
      ),
      content: Text(
        content,
        style: GudaTypography.body1(color: colorScheme.onSurfaceVariant),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onCancel?.call();
            Navigator.pop(context, false);
          },
          child: Text(
            cancelLabel,
            style: GudaTypography.button(color: colorScheme.outline),
          ),
        ),
        TextButton(
          onPressed: () {
            onConfirm?.call();
            Navigator.pop(context, true);
          },
          child: Text(
            confirmLabel,
            style: GudaTypography.button(
              color: isDestructive ? colorScheme.error : colorScheme.primary,
            ),
          ),
        ),
      ],
    ).gudaScaleIn(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
    );
  }
}
