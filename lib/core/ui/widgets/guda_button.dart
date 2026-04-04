import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// 버튼 변형 종류
enum GudaButtonVariant { filled, outlined, text }

/// Guda 공통 버튼 — 디자인 토큰 기반으로 하드코딩 없이 구성
class GudaButton extends StatelessWidget {
  const GudaButton._({
    super.key,
    required this.label,
    this.onPressed,
    required this.variant,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  /// 기본 채워진 버튼 (Primary)
  factory GudaButton.filled({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
    Color? backgroundColor,
    Color? foregroundColor,
  }) => GudaButton._(
    key: key,
    label: label,
    onPressed: onPressed,
    variant: GudaButtonVariant.filled,
    icon: icon,
    isLoading: isLoading,
    isFullWidth: isFullWidth,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
  );

  /// 외곽선 버튼 (Secondary)
  factory GudaButton.outlined({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
  }) => GudaButton._(
    key: key,
    label: label,
    onPressed: onPressed,
    variant: GudaButtonVariant.outlined,
    icon: icon,
    isLoading: isLoading,
    isFullWidth: isFullWidth,
  );

  /// 텍스트 버튼
  factory GudaButton.text({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    IconData? icon,
  }) => GudaButton._(
    key: key,
    label: label,
    onPressed: onPressed,
    variant: GudaButtonVariant.text,
    icon: icon,
  );

  final String label;
  final VoidCallback? onPressed;
  final GudaButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final child = _buildChild(colorScheme);
    final button = _buildButton(context, colorScheme, child);
    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }

  Widget _buildChild(ColorScheme cs) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == GudaButtonVariant.filled ? cs.onPrimary : cs.primary,
          ),
        ),
      );
    }
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: GudaSpacing.sm),
          Text(label, style: GudaTypography.button()),
        ],
      );
    }
    return Text(label, style: GudaTypography.button());
  }

  Widget _buildButton(BuildContext context, ColorScheme cs, Widget child) {
    VoidCallback? effectiveOnPressed = (isLoading || onPressed == null)
        ? null
        : () {
            HapticFeedback.lightImpact();
            onPressed!.call();
          };

    switch (variant) {
      case GudaButtonVariant.filled:
        return FilledButton(
          onPressed: effectiveOnPressed,
          style: FilledButton.styleFrom(
            backgroundColor: backgroundColor ?? cs.primary,
            foregroundColor: foregroundColor ?? cs.onPrimary,
            padding: const EdgeInsets.symmetric(
              horizontal: GudaSpacing.lg,
              vertical: GudaSpacing.md12,
            ),
            shape: const RoundedRectangleBorder(borderRadius: GudaRadius.mdAll),
          ),
          child: child,
        );
      case GudaButtonVariant.outlined:
        return OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: cs.primary,
            side: BorderSide(color: cs.outline),
            padding: const EdgeInsets.symmetric(
              horizontal: GudaSpacing.lg,
              vertical: GudaSpacing.md12,
            ),
            shape: const RoundedRectangleBorder(borderRadius: GudaRadius.mdAll),
          ),
          child: child,
        );
      case GudaButtonVariant.text:
        return TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            foregroundColor: cs.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: GudaSpacing.md,
              vertical: GudaSpacing.sm,
            ),
          ),
          child: child,
        );
    }
  }
}
