import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_text_input_field.dart';

class ChatInputTextField extends StatelessWidget {
  const ChatInputTextField({
    super.key,
    required this.controller,
    required this.enabled,
    required this.onSubmitted,
    this.maxLength,
  });

  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String> onSubmitted;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return GudaTextInputField(
      controller: controller,
      hintText: '메시지를 입력하세요...',
      maxLines: null,
      enabled: enabled,
      onSubmitted: onSubmitted,
      inputFormatters: maxLength != null
          ? [LengthLimitingTextInputFormatter(maxLength)]
          : null,
    );
  }
}
