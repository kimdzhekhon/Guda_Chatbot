import 'package:flutter/material.dart';

/// 앱 반응형 레이아웃 브레이크포인트
enum AppBreakpoint {
  /// 모바일 — 600dp 미만
  mobile,

  /// 태블릿 — 600dp 이상 1200dp 미만
  tablet,

  /// 데스크톱 — 1200dp 이상
  desktop;

  /// 현재 화면 폭으로부터 브레이크포인트 판별
  static AppBreakpoint of(double width) {
    if (width < 600) return mobile;
    if (width < 1200) return tablet;
    return desktop;
  }

  bool get isMobile => this == mobile;
  bool get isTablet => this == tablet;
  bool get isDesktop => this == desktop;
  bool get isTabletOrDesktop => this != mobile;
}

/// 반응형 레이아웃 데이터 — 브레이크포인트와 화면 크기 정보 보관
class AppResponsiveLayoutData {
  const AppResponsiveLayoutData({
    required this.breakpoint,
    required this.screenWidth,
    required this.screenHeight,
  });

  final AppBreakpoint breakpoint;
  final double screenWidth;
  final double screenHeight;

  bool get isMobile => breakpoint.isMobile;
  bool get isTablet => breakpoint.isTablet;
  bool get isDesktop => breakpoint.isDesktop;
  bool get isTabletOrDesktop => breakpoint.isTabletOrDesktop;
}

/// AppResponsiveLayout — 모든 UI 화면 크기 분기의 단일 진입점
/// 직접적인 MediaQuery.of(context).size 분기 코드를 이 위젯으로 대체해야 함
class AppResponsiveLayout extends StatelessWidget {
  const AppResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  /// 모바일 레이아웃 빌더 (필수)
  final Widget Function(BuildContext context, AppResponsiveLayoutData data)
  mobile;

  /// 태블릿 레이아웃 빌더 (미지정 시 모바일 레이아웃 사용)
  final Widget Function(BuildContext context, AppResponsiveLayoutData data)?
  tablet;

  /// 데스크톱 레이아웃 빌더 (미지정 시 태블릿 → 모바일 순으로 폴백)
  final Widget Function(BuildContext context, AppResponsiveLayoutData data)?
  desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = MediaQuery.sizeOf(context).height;
        final bp = AppBreakpoint.of(width);
        final data = AppResponsiveLayoutData(
          breakpoint: bp,
          screenWidth: width,
          screenHeight: height,
        );

        return switch (bp) {
          AppBreakpoint.desktop =>
            desktop?.call(context, data) ??
                tablet?.call(context, data) ??
                mobile(context, data),
          AppBreakpoint.tablet =>
            tablet?.call(context, data) ?? mobile(context, data),
          AppBreakpoint.mobile => mobile(context, data),
        };
      },
    );
  }
}
