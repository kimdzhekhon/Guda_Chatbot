import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// Guda 원형 액션 버튼 (전송 버튼 등)
/// 로딩 상태와 애니메이션 효과를 내장합니다.
class GudaActionCircleButton extends StatelessWidget {
  const GudaActionCircleButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.isLoading = false,
    this.isEnabled = true,
    this.size = 48.0,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final bool isLoading;
  final bool isEnabled;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: isEnabled && !isLoading
            ? colorScheme.primary
            : colorScheme.surfaceContainerHighest,
        borderRadius: GudaRadius.fullAll,
        child: InkWell(
          onTap: isEnabled && !isLoading ? onPressed : null,
          borderRadius: GudaRadius.fullAll,
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            child: isLoading
                ? SizedBox(
                    width: size * 0.45,
                    height: size * 0.45,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : Icon(
                    icon,
                    color: isEnabled
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
                    size: size * 0.45,
                  ),
          ),
        ),
      ),
    );
  }
}
