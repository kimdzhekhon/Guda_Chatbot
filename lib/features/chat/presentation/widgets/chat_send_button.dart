import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_action_circle_button.dart';

class ChatSendButton extends StatelessWidget {
  const ChatSendButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.isEnabled,
  });

  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return GudaActionCircleButton(
      onPressed: onPressed,
      icon: Icons.arrow_upward_rounded,
      isLoading: isLoading,
      isEnabled: isEnabled,
    );
  }
}
