import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

class AuthModeSwitcher extends StatelessWidget {
  const AuthModeSwitcher({
    super.key,
    required this.isSignUp,
    required this.onToggle,
  });

  final bool isSignUp;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onToggle,
        child: Text(
          isSignUp ? '이미 계정이 있으신가요? 로그인' : '계정이 없으신가요? 회원가입',
          style: GudaTypography.caption(
            color: context.colorScheme.primary,
          ).copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
