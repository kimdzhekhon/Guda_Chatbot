import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_animations.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'guda_button.dart';

/// Guda 오류 위젯 — 에러 상태 표시 및 재시도 버튼 포함
class GudaErrorWidget extends StatelessWidget {
  const GudaErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.errorCode,
  });

  /// 오류 메시지
  final String message;

  /// 재시도 콜백 (null이면 버튼 미표시)
  final VoidCallback? onRetry;

  /// 오류 코드 (선택)
  final String? errorCode;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(GudaSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: colorScheme.error.withValues(alpha: 0.8),
            ),
            const SizedBox(height: GudaSpacing.md),
            Text(
              message,
              style: GudaTypography.body1(color: colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            if (errorCode != null) ...[
              const SizedBox(height: GudaSpacing.sm),
              Text(
                '오류 코드: $errorCode',
                style: GudaTypography.caption(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: GudaSpacing.lg),
              GudaButton.outlined(
                label: '다시 시도',
                onPressed: onRetry!,
                icon: Icons.refresh_rounded,
              ),
            ],
          ],
        ),
      ),
    ).gudaFadeIn(duration: const Duration(milliseconds: 300)).gudaSlideIn(begin: const Offset(0, 0.05));
  }
}
