import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_card.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_auth_field.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_auth_button.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';
import 'package:guda_chatbot/features/auth/presentation/widgets/social_login_section.dart';
import 'package:guda_chatbot/features/auth/presentation/widgets/auth_mode_switcher.dart';

class AuthFormCard extends StatefulWidget {
  const AuthFormCard({
    super.key,
    required this.isLoading,
    required this.onEmailAuth,
    required this.emailController,
    required this.passwordController,
  });

  final bool isLoading;
  final Function(bool isSignUp) onEmailAuth;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<AuthFormCard> createState() => _AuthFormCardState();
}

class _AuthFormCardState extends State<AuthFormCard> {
  bool _isSignUp = false;

  @override
  Widget build(BuildContext context) {
    return GudaCard(
      padding: const EdgeInsets.symmetric(
        horizontal: GudaSpacing.lg,
        vertical: GudaSpacing.xl,
      ),
      backgroundColor: context.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isSignUp ? '회원가입' : '반갑습니다',
            style: GudaTypography.heading2(
              color: context.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: GudaSpacing.xs),
          Text(
            _isSignUp ? '지혜의 여정을 시작해보세요' : '다시 오신 것을 환영합니다',
            style: GudaTypography.body2(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: GudaSpacing.lg),
          GudaAuthField(
            controller: widget.emailController,
            labelText: '이메일',
            hintText: 'example@email.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: GudaSpacing.md),
          GudaAuthField(
            controller: widget.passwordController,
            labelText: '비밀번호',
            hintText: '6자 이상',
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => widget.onEmailAuth(_isSignUp),
          ),
          const SizedBox(height: GudaSpacing.md),
          GudaAuthButton(
            onPressed: widget.isLoading ? null : () => widget.onEmailAuth(_isSignUp),
            label: _isSignUp ? '가입하기' : '로그인',
            isLoading: widget.isLoading,
          ),
          AuthModeSwitcher(
            isSignUp: _isSignUp,
            onToggle: () => setState(() => _isSignUp = !_isSignUp),
          ),
          const SizedBox(height: GudaSpacing.sm),
          SocialLoginSection(
            isSignUp: _isSignUp,
            isLoading: widget.isLoading,
          ),
        ],
      ),
    );
  }
}
