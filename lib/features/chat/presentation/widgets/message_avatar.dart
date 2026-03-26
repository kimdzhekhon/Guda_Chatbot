import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_bot_avatar.dart';

class MessageAvatar extends StatelessWidget {
  const MessageAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: GudaSpacing.sm, left: GudaSpacing.md),
      child: GudaBotAvatar(),
    );
  }
}
