import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Guda 공통 Lottie 래퍼 위젯
///
/// [path]: AppAssets 상수의 Lottie JSON 경로
/// [size]: 위젯의 너비/높이 (정사각형)
/// [width], [height]: size 대신 개별 지정 가능
/// [repeat]: 반복 재생 여부 (기본 true)
/// [fit]: BoxFit 설정 (기본 contain)
class GudaLottie extends StatelessWidget {
  const GudaLottie({
    super.key,
    required this.path,
    this.size,
    this.width,
    this.height,
    this.repeat = true,
    this.fit = BoxFit.contain,
  });

  final String path;
  final double? size;
  final double? width;
  final double? height;
  final bool repeat;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      path,
      width: size ?? width,
      height: size ?? height,
      repeat: repeat,
      fit: fit,
    );
  }
}
