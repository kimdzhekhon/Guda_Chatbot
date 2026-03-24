import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_loading_widget.dart';

/// Guda 공통 로딩 오버레이
/// 비동기 작업 중 화면 상호작용을 차단합니다.
class GudaLoadingOverlay extends StatelessWidget {
  const GudaLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message = AppStrings.processing,
  });

  final bool isLoading;
  final Widget child;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: Center(
              child: GudaLoadingWidget(message: message),
            ),
          ),
      ],
    );
  }
}
