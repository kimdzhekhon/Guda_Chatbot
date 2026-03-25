import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/core/ui/layout/app_responsive_layout.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_card.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_animations.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_social_button.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_gradient_background.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_brand_header.dart';
import 'package:guda_chatbot/core/constants/app_assets.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_snack_bar.dart';
import 'package:guda_chatbot/features/auth/domain/entities/guda_user.dart';
import 'package:guda_chatbot/features/auth/presentation/viewmodels/auth_viewmodel.dart';

/// SCR_AUTH_GOOGLE — Google 소셜 로그인 화면
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
        GudaSnackBar.show(
          context,
          message: next.message,
          isError: true,
        );
      }
    });

    return Scaffold(
      body: GudaGradientBackground(
        child: AppResponsiveLayout(
          mobile: (context, data) {
            final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.xl),
              child: Column(
                children: [
                  if (!isKeyboardOpen) const Spacer(flex: 2),
                  const GudaBrandHeader(
                    subtitle: AppStrings.authSubtitle,
                  ),
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
                    AppStrings.version,
                    style: GudaTypography.caption2(
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
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
      backgroundColor: colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.authTitleLine1,
            style: GudaTypography.heading2(
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            AppStrings.authTitleLine2,
            style: GudaTypography.heading2(
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: GudaSpacing.sm),
          Text(
            AppStrings.authDesc,
            style: GudaTypography.body2(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: GudaSpacing.xl),

          // Google 로그인 버튼
          GudaSocialButton(
            onPressed: onGoogleSignIn,
            isLoading: isLoading,
            iconPath: AppAssets.googleIcon,
            label: AppStrings.continueWithGoogle,
            backgroundColor: Colors.white,
            foregroundColor: GudaColors.onSurfaceLight,
          ),

          const SizedBox(height: GudaSpacing.md),

          // Apple 로그인 버튼
          GudaSocialButton(
            onPressed: onAppleSignIn,
            isLoading: isLoading,
            iconPath: AppAssets.appleIcon,
            label: AppStrings.continueWithApple,
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
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
