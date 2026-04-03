import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_page_indicator.dart';

/// Guda 공통 PageView 슬라이더 위젯
/// PageController 생명주기, 페이지 인디케이터, 스케일 애니메이션을 내장합니다.
class GudaPageSlider<T> extends StatefulWidget {
  const GudaPageSlider({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.height,
    this.viewportFraction = 0.85,
    this.initialPage = 0,
    this.onPageChanged,
    this.showIndicator = true,
    this.enableScale = false,
    this.isScrollable = true,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, bool isActive) itemBuilder;
  final double height;
  final double viewportFraction;
  final int initialPage;
  final ValueChanged<int>? onPageChanged;
  final bool showIndicator;
  final bool enableScale;
  final bool isScrollable;

  @override
  State<GudaPageSlider<T>> createState() => _GudaPageSliderState<T>();
}

class _GudaPageSliderState<T> extends State<GudaPageSlider<T>> {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(
      viewportFraction: widget.viewportFraction,
      initialPage: widget.initialPage,
    );
  }

  @override
  void didUpdateWidget(GudaPageSlider<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _currentPage = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(0);
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    widget.onPageChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: _onPageChanged,
            physics: widget.isScrollable
                ? null
                : const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final isActive = _currentPage == index;
              final child = widget.itemBuilder(
                context,
                widget.items[index],
                isActive,
              );

              if (widget.enableScale) {
                return AnimatedScale(
                  scale: isActive ? 1.0 : 0.9,
                  duration: const Duration(milliseconds: 300),
                  child: child,
                );
              }

              return child;
            },
          ),
        ),
        if (widget.showIndicator) ...[
          const SizedBox(height: GudaSpacing.lg),
          GudaPageIndicator(
            count: widget.items.length,
            currentIndex: _currentPage,
          ),
        ],
      ],
    );
  }
}
