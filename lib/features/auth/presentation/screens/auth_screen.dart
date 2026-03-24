import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_animations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/core/ui/layout/app_responsive_layout.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_card.dart';
import 'package:guda_chatbot/features/auth/presentation/widgets/social_login_button.dart';
import 'package:guda_chatbot/features/auth/domain/entities/guda_user.dart';
import 'package:guda_chatbot/features/auth/presentation/viewmodels/auth_viewmodel.dart';

/// SCR_AUTH_GOOGLE — Google 소셜 로그인 화면
/// 기획서 SCR_AUTH_PW 대체 (소셜 로그인으로 개편)
class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authViewModelProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isLoading = state.isLoading;

    // 오류 스낵바
    ref.listen(authViewModelProvider, (_, next) {
      if (next is UiError<GudaUser?>) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(borderRadius: GudaRadius.smAll),
          ),
        );
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              GudaColors.primary,
              GudaColors.primaryLight,
              GudaColors.backgroundLight,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: AppResponsiveLayout(
          mobile: (context, data) {
            final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.xl),
              child: Column(
                children: [
                  if (!isKeyboardOpen) const Spacer(flex: 2),
                  const AuthBrandHeader(),
                  if (!isKeyboardOpen) const Spacer(flex: 2),
                  AuthLoginCard(
                    isLoading: isLoading,
                    onGoogleSignIn: () => ref
                        .read(authViewModelProvider.notifier)
                        .signInWithGoogle(),
                    onAppleSignIn: () => ref
                        .read(authViewModelProvider.notifier)
                        .signInWithApple(),
                  ),
                  const Spacer(flex: 1),
                  Text(
                    'Guda v1.0.0',
                    style: GudaTypography.brand(
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ).copyWith(fontSize: 12),
                  ).gudaFadeIn(delay: const Duration(milliseconds: 600)),
                  const SizedBox(height: GudaSpacing.lg),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class AuthBrandHeader extends StatelessWidget {
  const AuthBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/app_logo_transparent.png',
          width: 120,
          height: 120,
        ).gudaScaleIn(
          duration: const Duration(milliseconds: 700),
          curve: Curves.elasticOut,
        ),
        const SizedBox(height: GudaSpacing.lg),
        Text(
          'G u d a',
          style: GudaTypography.brand(color: Colors.white),
        ).gudaFadeIn(delay: const Duration(milliseconds: 200)),
        const SizedBox(height: GudaSpacing.sm),
        Text(
          '팔만대장경 · 주역 · 구사론',
          style: GudaTypography.body2(
            color: Colors.white.withValues(alpha: 0.75),
          ),
        ).gudaFadeIn(delay: const Duration(milliseconds: 350)),
      ],
    );
  }
}

class AuthLoginCard extends StatelessWidget {
  const AuthLoginCard({
    super.key,
    required this.isLoading,
    required this.onGoogleSignIn,
    required this.onAppleSignIn,
  });

  final bool isLoading;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onAppleSignIn;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GudaCard(
      padding: const EdgeInsets.all(GudaSpacing.xl),
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '동서고금의 지혜와',
            style: GudaTypography.heading2(
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            '깊이 있는 대화를 나누세요',
            style: GudaTypography.heading2(
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: GudaSpacing.sm),
          Text(
            '고전 AI 챗봇 Guda와 함께\n불교와 유교의 가르침을 탐구합니다.',
            style: GudaTypography.body2(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: GudaSpacing.xl),

          // Google 로그인 버튼
          SizedBox(
            width: double.infinity,
            height: 54,
            child: SocialLoginButton(
              onPressed: isLoading ? null : onGoogleSignIn,
              isLoading: isLoading,
              iconPath: 'assets/images/google_logo.png',
              label: 'Google로 계속하기',
              backgroundColor: Colors.white,
              foregroundColor: GudaColors.onSurfaceLight,
            ),
          ),

          const SizedBox(height: GudaSpacing.md),

          // Apple 로그인 버튼
          SizedBox(
            width: double.infinity,
            height: 54,
            child: SocialLoginButton(
              onPressed: isLoading ? null : onAppleSignIn,
              isLoading: isLoading,
              iconPath: 'assets/images/apple_logo.png',
              label: 'Apple로 계속하기',
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    ).gudaSlideIn(
      begin: const Offset(0, 0.1),
      delay: const Duration(milliseconds: 400),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }
}
