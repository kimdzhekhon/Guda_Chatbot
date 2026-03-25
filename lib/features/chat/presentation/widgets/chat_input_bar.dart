import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_action_circle_button.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_text_input_field.dart';

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
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? GudaColors.surfaceDark : GudaColors.surfaceLight,
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
                child: GudaTextInputField(
                  controller: _controller,
                  isDark: isDark,
                  hintText: '메시지를 입력하세요...',
                  maxLines: null,
                  enabled: !widget.isLoading,
                  onSubmitted: (_) => _send(),
                ),
              ),
              const SizedBox(width: GudaSpacing.sm),

              // ── 전송 버튼 ─────────────────────────
              GudaActionCircleButton(
                onPressed: _send,
                icon: Icons.arrow_upward_rounded,
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
