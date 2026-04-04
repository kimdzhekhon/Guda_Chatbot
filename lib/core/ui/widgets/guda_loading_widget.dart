import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_animations.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// Guda 로딩 위젯 — 전역 로딩 상태 표시
class GudaLoadingWidget extends StatelessWidget {
  const GudaLoadingWidget({super.key, this.message, this.color});

  /// 로딩 메시지 (선택)
  final String? message;

  /// 인디케이터 색상 (선택)
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(color ?? colorScheme.secondary),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: GudaSpacing.md),
            Text(
              message!,
              style: GudaTypography.body2(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    ).gudaFadeIn(duration: GudaDuration.normal);
  }
}
