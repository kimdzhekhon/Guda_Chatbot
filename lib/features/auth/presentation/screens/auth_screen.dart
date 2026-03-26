import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_animations.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/core/ui/layout/app_responsive_layout.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_card.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_social_button.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_gradient_background.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_brand_header.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_snack_bar.dart';
import 'package:guda_chatbot/features/auth/domain/entities/guda_user.dart';
import 'package:guda_chatbot/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_terms_bottom_sheet.dart';

/// 로그인/회원가입 화면 — 이메일 + 소셜 로그인
class AuthScreen extends ConsumerStatefulWidget {
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
    final colorScheme = Theme.of(context).colorScheme;

    // Error snackbar
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
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        if (!isKeyboardOpen) const Spacer(flex: 1),
                        const GudaBrandHeader(
                          subtitle: AppStrings.authSubtitle,
                        ),
                        if (!isKeyboardOpen) const Spacer(flex: 1),
                        const SizedBox(height: GudaSpacing.md),
                        
                        // Auth Card (Email + Social)
                        GudaCard(
                          padding: const EdgeInsets.symmetric(
                            horizontal: GudaSpacing.lg,
                            vertical: GudaSpacing.xl,
                          ),
                          backgroundColor: colorScheme.surface,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isSignUp ? '회원가입' : '반갑습니다',
                                style: GudaTypography.heading2(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: GudaSpacing.xs),
                              Text(
                                _isSignUp 
                                    ? '지혜의 여정을 시작해보세요'
                                    : '다시 오신 것을 환영합니다',
                                style: GudaTypography.body2(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: GudaSpacing.lg),

                              // Email field
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: '이메일',
                                  hintText: 'example@email.com',
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: GudaRadius.mdAll,
                                  ),
                                ),
                              ),
                              const SizedBox(height: GudaSpacing.md),

                              // Password field
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: '비밀번호',
                                  hintText: '6자 이상',
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: GudaRadius.mdAll,
                                  ),
                                ),
                                onSubmitted: (_) => _handleEmailAuth(),
                              ),
                              const SizedBox(height: GudaSpacing.md),

                              // Email Action Button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _handleEmailAuth,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: GudaColors.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: GudaRadius.mdAll,
                                    ),
                                    elevation: 0,
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : Text(
                                          _isSignUp ? '가입하기' : '로그인',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),

                              // Toggle Login/SignUp
                              Center(
                                child: TextButton(
                                  onPressed: () => setState(() => _isSignUp = !_isSignUp),
                                  child: Text(
                                    _isSignUp ? '이미 계정이 있으신가요? 로그인' : '계정이 없으신가요? 회원가입',
                                    style: TextStyle(
                                      color: GudaColors.primary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: GudaSpacing.sm),
                              
                              // Divider
                              Row(
                                children: [
                                  Expanded(child: Divider(color: colorScheme.outlineVariant, thickness: 0.5)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.md),
                                    child: Text('또는', style: GudaTypography.caption2(color: colorScheme.onSurfaceVariant)),
                                  ),
                                  Expanded(child: Divider(color: colorScheme.outlineVariant, thickness: 0.5)),
                                ],
                              ),
                              const SizedBox(height: GudaSpacing.md),

                              // Social Buttons
                                GudaSocialButton(
                                  onPressed: () async {
                                    final agreed = await GudaTermsBottomSheet.show(context);
                                    if (agreed == true) {
                                      ref.read(authViewModelProvider.notifier).signInWithGoogle();
                                    }
                                  },
                                  isLoading: isLoading,
                                  provider: GudaSocialProvider.google,
                                ),
                                const SizedBox(height: GudaSpacing.md),
                                GudaSocialButton(
                                  onPressed: () async {
                                    final agreed = await GudaTermsBottomSheet.show(context);
                                    if (agreed == true) {
                                      ref.read(authViewModelProvider.notifier).signInWithApple();
                                    }
                                  },
                                  isLoading: isLoading,
                                  provider: GudaSocialProvider.apple,
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
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleEmailAuth() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) return;

    if (_isSignUp) {
      GudaTermsBottomSheet.show(context).then((agreed) {
        if (agreed == true) {
          ref.read(authViewModelProvider.notifier).signUpWithEmail(email, password);
        }
      });
    } else {
      ref.read(authViewModelProvider.notifier).signInWithEmail(email, password);
    }
  }
}
