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

<<<<<<< feature/email-auth
/// 로그인/회원가입 화면 — 이메일 + 소셜 로그인
class AuthScreen extends ConsumerStatefulWidget {
=======
/// SCR_AUTH_GOOGLE — Google 소셜 로그인 화면
class AuthScreen extends ConsumerWidget {
>>>>>>> dev
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authViewModelProvider);
    final isLoading = state.isLoading;

    // Error snackbar
    ref.listen(authViewModelProvider, (_, next) {
      if (next is UiError<GudaUser?>) {
<<<<<<< feature/email-auth
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message, style: const TextStyle(fontSize: 16)),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(borderRadius: GudaRadius.smAll),
          ),
=======
        GudaSnackBar.show(
          context,
          message: next.message,
          isError: true,
>>>>>>> dev
        );
      }
    });

    return Scaffold(
<<<<<<< feature/email-auth
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.xl),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: GudaSpacing.xxl),

                  // Logo
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/app_logo_transparent.png',
                        width: 100,
                        height: 100,
                      ).animate().scale(
                        duration: 700.ms,
                        curve: Curves.elasticOut,
                      ),
                      const SizedBox(height: GudaSpacing.md),
                      Text(
                        'G u d a',
                        style: GudaTypography.brand(color: Colors.white),
                      ).animate().fadeIn(delay: 200.ms),
                      const SizedBox(height: GudaSpacing.xs),
                      Text(
                        '팔만대장경 · 주역 · 구사론',
                        style: GudaTypography.body2(
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                      ).animate().fadeIn(delay: 350.ms),
                    ],
                  ),

                  const SizedBox(height: GudaSpacing.xxl),

                  // Login card
                  Container(
                    padding: const EdgeInsets.all(GudaSpacing.xl),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: GudaRadius.lgAll,
                      boxShadow: GudaShadows.modal,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isSignUp ? '회원가입' : '로그인',
                          style: GudaTypography.heading2(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: GudaSpacing.lg),

                        // Email field
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            labelText: '이메일',
                            labelStyle: const TextStyle(fontSize: 16),
                            hintText: 'example@email.com',
                            border: OutlineInputBorder(
                              borderRadius: GudaRadius.mdAll,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: GudaSpacing.md,
                              vertical: GudaSpacing.md,
                            ),
                          ),
                        ),
                        const SizedBox(height: GudaSpacing.md),

                        // Password field
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            labelText: '비밀번호',
                            labelStyle: const TextStyle(fontSize: 16),
                            hintText: '6자 이상',
                            border: OutlineInputBorder(
                              borderRadius: GudaRadius.mdAll,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: GudaSpacing.md,
                              vertical: GudaSpacing.md,
                            ),
                          ),
                          onSubmitted: (_) => _handleEmailAuth(),
                        ),
                        const SizedBox(height: GudaSpacing.lg),

                        // Email login/signup button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _handleEmailAuth,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: GudaColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: GudaRadius.mdAll,
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    _isSignUp ? '가입하기' : '로그인',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),

                        // Toggle login/signup
                        const SizedBox(height: GudaSpacing.sm),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              setState(() => _isSignUp = !_isSignUp);
                            },
                            child: Text(
                              _isSignUp
                                  ? '이미 계정이 있으신가요? 로그인'
                                  : '계정이 없으신가요? 회원가입',
                              style: TextStyle(
                                fontSize: 15,
                                color: GudaColors.primary,
                              ),
                            ),
                          ),
                        ),

                        // Divider
                        const SizedBox(height: GudaSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(color: GudaColors.dividerLight),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: GudaSpacing.md,
                              ),
                              child: Text(
                                '또는',
                                style: GudaTypography.caption(
                                  color: GudaColors.onSurfaceLight
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(color: GudaColors.dividerLight),
                            ),
                          ],
                        ),
                        const SizedBox(height: GudaSpacing.md),

                        // Google login button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: _SocialLoginButton(
                            onPressed: isLoading
                                ? null
                                : () => ref
                                    .read(authViewModelProvider.notifier)
                                    .signInWithGoogle(),
                            isLoading: false,
                            iconPath: 'assets/images/google_logo.png',
                            label: 'Google로 계속하기',
                            backgroundColor: Colors.white,
                            foregroundColor: GudaColors.onSurfaceLight,
                          ),
                        ),

                        const SizedBox(height: GudaSpacing.md),

                        // Apple login button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: _SocialLoginButton(
                            onPressed: isLoading
                                ? null
                                : () => ref
                                    .read(authViewModelProvider.notifier)
                                    .signInWithApple(),
                            isLoading: false,
                            iconPath: 'assets/images/apple_logo.png',
                            label: 'Apple로 계속하기',
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ).animate().slideY(
                    begin: 0.1,
                    delay: 400.ms,
                    duration: 500.ms,
                    curve: Curves.easeOut,
                  ),

                  const SizedBox(height: GudaSpacing.lg),

                  // App version
                  Text(
                    'Guda v1.0.0',
                    style: GudaTypography.caption(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.5),
                    ),
                  ).animate().fadeIn(delay: 600.ms),
                  const SizedBox(height: GudaSpacing.lg),
                ],
              ),
            ),
          ),
=======
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
>>>>>>> dev
        ),
      ),
    );
  }

  void _handleEmailAuth() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) return;

    if (_isSignUp) {
      ref.read(authViewModelProvider.notifier).signUpWithEmail(email, password);
    } else {
      ref.read(authViewModelProvider.notifier).signInWithEmail(email, password);
    }
  }
}

<<<<<<< feature/email-auth
/// Social login button widget
class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({
    required this.onPressed,
=======
class AuthLoginCard extends StatelessWidget {
  const AuthLoginCard({
    super.key,
>>>>>>> dev
    required this.isLoading,
    required this.onGoogleSignIn,
    required this.onAppleSignIn,
  });

  final bool isLoading;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onAppleSignIn;

  @override
  Widget build(BuildContext context) {
<<<<<<< feature/email-auth
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: backgroundColor == Colors.white ? 2 : 0,
        shadowColor: GudaColors.primary.withValues(alpha: 0.15),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: GudaRadius.mdAll,
          side: backgroundColor == Colors.white
              ? const BorderSide(color: GudaColors.dividerLight, width: 1)
              : BorderSide.none,
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
              ),
            )
          : Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: GudaSpacing.md,
                    ),
                    child: Image.asset(iconPath, width: 32, height: 32),
                  ),
                ),
                Text(
                  label,
                  style: GudaTypography.button(color: foregroundColor),
                ),
              ],
=======
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
>>>>>>> dev
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
