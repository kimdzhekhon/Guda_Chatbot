import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

/// Guda 공통 빈 화면/결과 없음 뷰
class GudaEmptyView extends StatelessWidget {
  const GudaEmptyView({
    super.key,
    required this.message,
    this.icon,
    this.subMessage,
    this.action,
  });

  /// 표시할 메인 메시지
  final String message;

  /// 상단에 표시할 아이콘 (선택)
  final IconData? icon;

  /// 하단에 표시할 추가 설명 (선택)
  final String? subMessage;

  /// 하단에 배치할 액션 위젯 (버튼 등, 선택)
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(GudaSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 64,
                color: context.onSurfaceVariantColor.withValues(alpha: 0.3),
              ),
              const SizedBox(height: GudaSpacing.lg),
            ],
            Text(
              message,
              style: GudaTypography.body1(
                color: context.onSurfaceVariantColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (subMessage != null) ...[
              const SizedBox(height: GudaSpacing.sm),
              Text(
                subMessage!,
                style: GudaTypography.body2(
                  color: context.onSurfaceVariantColor.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: GudaSpacing.xl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
