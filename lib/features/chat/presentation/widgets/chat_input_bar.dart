import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

import 'package:guda_chatbot/features/chat/presentation/widgets/chat_input_text_field.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/chat_send_button.dart';

/// 채팅 입력창 위젯
class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key, required this.onSend, this.isLoading = false});

  /// 메시지 전송 콜백
  final ValueChanged<String> onSend;

  /// 전송 중 로딩 여부 (스트리밍 응답 대기 시 입력 비활성화)
  final bool isLoading;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _hasText = _controller.text.trim().isNotEmpty);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isLoading) return;
    _controller.clear();
    widget.onSend(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        boxShadow: GudaShadows.inputBar,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: GudaSpacing.md,
            vertical: GudaSpacing.sm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // ── 텍스트 입력 영역 ────────────────────
              Expanded(
                child: ChatInputTextField(
                  controller: _controller,
                  enabled: !widget.isLoading,
                  onSubmitted: (_) => _send(),
                ),
              ),
              const SizedBox(width: GudaSpacing.sm),

              // ── 전송 버튼 ─────────────────────────
              ChatSendButton(
                onPressed: _send,
                isLoading: widget.isLoading,
                isEnabled: _hasText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
