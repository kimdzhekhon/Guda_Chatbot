import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/ui/layout/app_responsive_layout.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_loading_overlay.dart';

/// Guda 공통 Scaffold 위젯
/// 반응형 레이아웃(AppResponsiveLayout), 배경색 처리, 태블릿/데스크톱 최대 너비 제한을 단일화합니다.
class GudaScaffold extends StatelessWidget {
  const GudaScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.drawer,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.useSafeArea = true,
    this.background,
    this.isLoading = false,
    this.loadingMessage,
  });

  /// 메인 바디 위젯
  final Widget body;

  /// 앱바
  final PreferredSizeWidget? appBar;

  /// 드로어
  final Widget? drawer;

  /// 하단 내비게이션 바
  final Widget? bottomNavigationBar;

  /// 플로팅 액션 버튼
  final Widget? floatingActionButton;

  /// SafeArea 사용 여부 (기본값: true)
  final bool useSafeArea;

  /// 배경 위젯 (그라데이션 등) — 지정 시 backgroundColor는 무시될 수 있음
  final Widget? background;

  /// 로딩 상태 여부
  final bool isLoading;

  /// 로딩 메시지 (선택 사항)
  final String? loadingMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background != null ? Colors.transparent : context.backgroundColor,
      appBar: appBar,
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      extendBody: background != null,
      extendBodyBehindAppBar: background != null,
      body: GudaLoadingOverlay(
        isLoading: isLoading,
        message: loadingMessage ?? '처리 중...',
        child: Stack(
          children: [
            if (background != null) Positioned.fill(child: background!),
            AppResponsiveLayout(
              useSafeArea: useSafeArea,
              mobile: (context, data) => body,
              tablet: (context, data) => Center(
                child: SizedBox(
                  width: 768,
                  child: body,
                ),
              ),
              desktop: (context, data) => Center(
                child: SizedBox(
                  width: 1024,
                  child: body,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
