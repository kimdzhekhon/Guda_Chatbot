import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_loading_widget.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_error_widget.dart';

/// AsyncValue의 loading/error/data 상태를 일관되게 처리하는 공통 위젯
/// GudaScaffold의 body로 사용합니다.
class GudaAsyncBody<T> extends StatelessWidget {
  const GudaAsyncBody({
    super.key,
    required this.asyncValue,
    required this.builder,
    this.onRetry,
    this.errorMessage,
  });

  final AsyncValue<T> asyncValue;
  final Widget Function(T data) builder;
  final VoidCallback? onRetry;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      data: builder,
      loading: () => const Center(child: GudaLoadingWidget()),
      error: (error, stack) => GudaErrorWidget(
        message: errorMessage ?? '데이터를 불러오지 못했습니다.',
        onRetry: onRetry,
      ),
    );
  }
}
