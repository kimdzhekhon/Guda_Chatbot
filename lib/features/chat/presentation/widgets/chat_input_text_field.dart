import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_text_input_field.dart';

class ChatInputTextField extends StatelessWidget {
  const ChatInputTextField({
    super.key,
    required this.controller,
    required this.enabled,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return GudaTextInputField(
      controller: controller,
      hintText: '메시지를 입력하세요...',
      maxLines: null,
      enabled: enabled,
      onSubmitted: onSubmitted,
    );
  }
}
