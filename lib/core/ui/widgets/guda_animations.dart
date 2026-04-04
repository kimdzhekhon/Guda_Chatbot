import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/tokens/animation_tokens.dart';

/// Guda 앱 공통 애니메이션 위젯 (라이브러리 사용 최소화를 위함)

/// 공통 애니메이션 초기화/해제 로직을 제공하는 믹스인
mixin GudaAnimationMixin<T extends StatefulWidget>
    on SingleTickerProviderStateMixin<T> {
  late AnimationController animController;

  void initAnimation({
    required Duration duration,
    required Duration delay,
  }) {
    animController = AnimationController(vsync: this, duration: duration);
    Future.delayed(delay, () {
      if (mounted) animController.forward();
    });
  }

  void disposeAnimation() {
    animController.dispose();
  }
}

class GudaFadeIn extends StatefulWidget {
  const GudaFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = GudaDuration.slow,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  @override
  State<GudaFadeIn> createState() => _GudaFadeInState();
}

class _GudaFadeInState extends State<GudaFadeIn>
    with SingleTickerProviderStateMixin, GudaAnimationMixin {
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    initAnimation(duration: widget.duration, delay: widget.delay);
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    disposeAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _opacity, child: widget.child);
  }
}

class GudaScaleIn extends StatefulWidget {
  const GudaScaleIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = GudaDuration.slow,
    this.curve = Curves.easeOut,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;

  @override
  State<GudaScaleIn> createState() => _GudaScaleInState();
}

class _GudaScaleInState extends State<GudaScaleIn>
    with SingleTickerProviderStateMixin, GudaAnimationMixin {
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    initAnimation(duration: widget.duration, delay: widget.delay);
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animController, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    disposeAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}

class GudaSlideIn extends StatefulWidget {
  const GudaSlideIn({
    super.key,
    required this.child,
    this.beginOffset = const Offset(0, 0.1),
    this.delay = Duration.zero,
    this.duration = GudaDuration.slow,
    this.curve = Curves.easeOut,
  });

  final Widget child;
  final Offset beginOffset;
  final Duration delay;
  final Duration duration;
  final Curve curve;

  @override
  State<GudaSlideIn> createState() => _GudaSlideInState();
}

class _GudaSlideInState extends State<GudaSlideIn>
    with SingleTickerProviderStateMixin, GudaAnimationMixin {
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    initAnimation(duration: widget.duration, delay: widget.delay);
    _offset = Tween<Offset>(begin: widget.beginOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: animController, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    disposeAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _offset, child: widget.child);
  }
}

class GudaFadeScaleIn extends StatefulWidget {
  const GudaFadeScaleIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = GudaDuration.slow,
    this.beginScale = 0.95,
    this.curve = Curves.easeOut,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double beginScale;
  final Curve curve;

  @override
  State<GudaFadeScaleIn> createState() => _GudaFadeScaleInState();
}

class _GudaFadeScaleInState extends State<GudaFadeScaleIn>
    with SingleTickerProviderStateMixin, GudaAnimationMixin {
  late Animation<double> _opacity;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    initAnimation(duration: widget.duration, delay: widget.delay);
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animController, curve: Curves.easeIn),
    );
    _scale = Tween<double>(begin: widget.beginScale, end: 1.0).animate(
      CurvedAnimation(parent: animController, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    disposeAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

/// Fade + Slide를 단일 AnimationController로 처리하는 통합 위젯
/// 기존: 2개의 AnimationController (GudaFadeIn + GudaSlideIn) → 개선: 1개의 AnimationController
class GudaFadeSlideIn extends StatefulWidget {
  const GudaFadeSlideIn({
    super.key,
    required this.child,
    this.beginOffset = const Offset(0, 0.1),
    this.delay = Duration.zero,
    this.duration = GudaDuration.slow,
    this.curve = Curves.easeOut,
  });

  final Widget child;
  final Offset beginOffset;
  final Duration delay;
  final Duration duration;
  final Curve curve;

  @override
  State<GudaFadeSlideIn> createState() => _GudaFadeSlideInState();
}

class _GudaFadeSlideInState extends State<GudaFadeSlideIn>
    with SingleTickerProviderStateMixin, GudaAnimationMixin {
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    initAnimation(duration: widget.duration, delay: widget.delay);
    final curved = CurvedAnimation(parent: animController, curve: widget.curve);
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(curved);
    _offset = Tween<Offset>(begin: widget.beginOffset, end: Offset.zero).animate(curved);
  }

  @override
  void dispose() {
    disposeAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}

/// Extension to make it as easy as flutter_animate
extension GudaAnimateExtension on Widget {
  Widget gudaFadeIn({
    Duration delay = Duration.zero,
    Duration duration = GudaDuration.slow,
  }) {
    return GudaFadeIn(delay: delay, duration: duration, child: this);
  }

  Widget gudaScaleIn({
    Duration delay = Duration.zero,
    Duration duration = GudaDuration.slow,
    Curve curve = Curves.easeOut,
    double begin = 0.0,
  }) {
    return GudaScaleIn(delay: delay, duration: duration, curve: curve, child: this);
  }

  Widget gudaFadeScaleIn({
    Duration delay = Duration.zero,
    Duration duration = GudaDuration.slow,
    double beginScale = 0.95,
    Curve curve = Curves.easeOut,
  }) {
    return GudaFadeScaleIn(
      delay: delay,
      duration: duration,
      beginScale: beginScale,
      curve: curve,
      child: this,
    );
  }

  Widget gudaSlideIn({
    Offset begin = const Offset(0, 0.1),
    Duration delay = Duration.zero,
    Duration duration = GudaDuration.slow,
    Curve curve = Curves.easeOut,
  }) {
    return GudaSlideIn(beginOffset: begin, delay: delay, duration: duration, curve: curve, child: this);
  }

  /// Fade + Slide를 단일 AnimationController로 처리 (gudaFadeIn + gudaSlideIn 대체)
  Widget gudaFadeSlideIn({
    Offset begin = const Offset(0, 0.1),
    Duration delay = Duration.zero,
    Duration duration = GudaDuration.slow,
    Curve curve = Curves.easeOut,
  }) {
    return GudaFadeSlideIn(
      beginOffset: begin,
      delay: delay,
      duration: duration,
      curve: curve,
      child: this,
    );
  }
}
