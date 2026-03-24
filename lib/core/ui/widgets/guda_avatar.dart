import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// Guda 공통 아바타 위젯
/// 프로필 이미지가 있을 경우 이미지를 보여주고, 없을 경우 이름을 바탕으로 기본 이니셜을 보여줍니다.
class GudaAvatar extends StatelessWidget {
  const GudaAvatar({
    super.key,
    this.photoUrl,
    required this.displayName,
    this.radius = 30.0,
  });

  final String? photoUrl;
  final String displayName;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (photoUrl != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(photoUrl!),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: colorScheme.primary,
      child: Text(
        displayName.isNotEmpty ? displayName.substring(0, 1).toUpperCase() : '?',
        style: GudaTypography.heading3(color: colorScheme.onPrimary).copyWith(
          fontSize: radius * 0.8,
        ),
      ),
    );
  }
}
