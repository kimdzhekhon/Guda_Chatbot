import 'package:flutter/material.dart';

/// Guda 앱 공통 애니메이션 위젯 (라이브러리 사용 최소화를 위함)
class GudaFadeIn extends StatefulWidget {
  const GudaFadeIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  @override
  State<GudaFadeIn> createState() => _GudaFadeInState();
}

class _GudaFadeInState extends State<GudaFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: widget.child,
    );
  }
}

class GudaScaleIn extends StatefulWidget {
  const GudaScaleIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
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
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: widget.child,
    );
  }
}

class GudaSlideIn extends StatefulWidget {
  const GudaSlideIn({
    super.key,
    required this.child,
    this.beginOffset = const Offset(0, 0.1),
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
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
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _offset = Tween<Offset>(begin: widget.beginOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offset,
      child: widget.child,
    );
  }
}


class GudaFadeScaleIn extends StatefulWidget {
  const GudaFadeScaleIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
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
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scale = Tween<double>(begin: widget.beginScale, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}

/// Extension to make it as easy as flutter_animate
extension GudaAnimateExtension on Widget {
  Widget gudaFadeIn({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return GudaFadeIn(delay: delay, duration: duration, child: this);
  }

  Widget gudaScaleIn({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeOut,
    double begin = 0.0,
  }) {
    return GudaScaleIn(delay: delay, duration: duration, curve: curve, child: this);
  }

  Widget gudaFadeScaleIn({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 500),
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
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeOut,
  }) {
    return GudaSlideIn(beginOffset: begin, delay: delay, duration: duration, curve: curve, child: this);
  }
}
