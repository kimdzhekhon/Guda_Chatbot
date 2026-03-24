import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.xl),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // ── 로고 영역 ────────────────────────
                Column(
                  children: [
                    Image.asset(
                      'assets/images/app_logo_transparent.png',
                      width: 120,
                      height: 120,
                    ).animate().scale(
                      duration: 700.ms,
                      curve: Curves.elasticOut,
                    ),
                    const SizedBox(height: GudaSpacing.lg),
                    Text(
                      'G u d a',
                      style: GudaTypography.brand(color: Colors.white),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: GudaSpacing.sm),
                    Text(
                      '팔만대장경 · 주역 · 구사론',
                      style: GudaTypography.body2(
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ).animate().fadeIn(delay: 350.ms),
                  ],
                ),

                const Spacer(flex: 2),

                // ── 로그인 카드 ──────────────────────
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
                        child: _SocialLoginButton(
                          onPressed: isLoading
                              ? null
                              : () => ref
                                    .read(authViewModelProvider.notifier)
                                    .signInWithGoogle(),
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
                        child: _SocialLoginButton(
                          onPressed: isLoading
                              ? null
                              : () => ref
                                    .read(authViewModelProvider.notifier)
                                    .signInWithApple(),
                          isLoading: isLoading,
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

                const Spacer(flex: 1),

                // 하단 앱 버전
                Text(
                  'Guda v1.0.0',
                  style: GudaTypography.caption(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: GudaSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 공통 소셜 로그인 버튼 위젯
class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({
    required this.onPressed,
    required this.isLoading,
    required this.iconPath,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final String iconPath;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
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
            ),
    );
  }
}
