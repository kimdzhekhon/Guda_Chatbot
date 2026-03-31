import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_animations.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_gradient_background.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_snack_bar.dart';
import 'package:guda_chatbot/features/auth/domain/entities/guda_user.dart';
import 'package:guda_chatbot/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_scaffold.dart';

import 'package:guda_chatbot/features/auth/presentation/widgets/auth_branding.dart';
import 'package:guda_chatbot/features/auth/presentation/widgets/social_login_section.dart';

import 'package:guda_chatbot/core/ui/widgets/guda_card.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isSignUp = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authViewModelProvider);
    final isLoading = state.isLoading;

    ref.listen(authViewModelProvider, (_, next) {
      if (next is UiError<GudaUser?>) {
        GudaSnackBar.show(
          context,
          message: next.message,
          isError: true,
        );
      }
    });

    return GudaScaffold(
      background: const GudaGradientBackground(child: SizedBox.expand()),
      body: _buildContent(context, isLoading),
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.xl),
      child: Column(
        children: [
          const Spacer(flex: 2),
          const AuthBranding().gudaFadeIn(
            duration: const Duration(milliseconds: 800),
          ),
          const Spacer(flex: 1),
          GudaCard(
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
                  style: GudaTypography.heading3(
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
                SocialLoginSection(
                  isSignUp: _isSignUp,
                  isLoading: isLoading,
                ),
                const SizedBox(height: GudaSpacing.lg),
                Center(
                  child: TextButton(
                    onPressed: () => setState(() => _isSignUp = !_isSignUp),
                    child: Text(
                      _isSignUp ? '이미 계정이 있으신가요? 로그인' : '처음이신가요? 회원가입',
                      style: GudaTypography.captionBold(
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).gudaSlideIn(
            begin: const Offset(0, 0.05),
            delay: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
