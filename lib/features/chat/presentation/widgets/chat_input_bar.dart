import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
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
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 120),
                  decoration: BoxDecoration(
                    color: isDark
                        ? GudaColors.surfaceVariantDark
                        : GudaColors.surfaceVariantLight,
                    borderRadius: GudaRadius.lgAll,
                  ),
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    enabled: !widget.isLoading,
                    style: GudaTypography.input(color: colorScheme.onSurface),
                    decoration: InputDecoration(
                      hintText: '메시지를 입력하세요...',
                      hintStyle: GudaTypography.input(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      fillColor: Colors.transparent,
                      filled: true,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: GudaRadius.lgAll,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: GudaSpacing.md,
                        vertical: GudaSpacing.md12,
                      ),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
              ),
              const SizedBox(width: GudaSpacing.sm),

              // ── 전송 버튼 ─────────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Material(
                  color: _hasText && !widget.isLoading
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: GudaRadius.fullAll,
                  child: InkWell(
                    onTap: _send,
                    borderRadius: GudaRadius.fullAll,
                    child: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      child: widget.isLoading
                          ? SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colorScheme.onSurfaceVariant,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.arrow_upward_rounded,
                              color: _hasText
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurfaceVariant,
                              size: 22,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
