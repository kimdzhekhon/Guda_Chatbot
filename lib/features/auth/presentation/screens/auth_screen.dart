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
import 'package:guda_chatbot/core/ui/widgets/guda_dialog.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';

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

    // 로그인 완료 후 라우터가 리다이렉트할 때까지 로딩 상태 유지
    final user = state is UiSuccess<GudaUser?> ? state.data : null;
    final isRedirecting = user != null;

    ref.listen(authViewModelProvider, (_, next) {
      if (next is UiError<GudaUser?>) {
        if (next.errorCode == AppStrings.errCodeReRegistrationForbidden) {
          GudaDialog.show(
            context,
            title: AppStrings.reRegistrationForbiddenTitle,
            content: next.message,
            showCancel: false,
          );
        } else {
          GudaSnackBar.show(
            context,
            message: next.message,
            isError: true,
          );
        }
      }
    });

    return GudaScaffold(
      isLoading: isLoading || isRedirecting,
      background: const GudaGradientBackground(child: SizedBox.expand()),
      body: isRedirecting ? const SizedBox.shrink() : _buildContent(context, isLoading),
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 360 ? GudaSpacing.md : GudaSpacing.lg;
    final cardPadding = screenWidth < 360 ? GudaSpacing.md : GudaSpacing.xl;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: constraints.maxHeight * 0.12),
                  const AuthBranding().gudaFadeIn(
                    duration: GudaDuration.slowest,
                  ),
                  const SizedBox(height: GudaSpacing.xxl),
                  GudaCard(
                    padding: EdgeInsets.all(cardPadding),
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
                        const SizedBox(height: GudaSpacing.xl),
                        const SocialLoginSection(
                          isLoading: false,
                        ),
                      ],
                    ),
                  ).gudaSlideIn(
                    begin: const Offset(0, 0.05),
                    delay: GudaDuration.normal,
                  ),
                  const SizedBox(height: GudaSpacing.md),
                  Center(
                    child: TextButton(
                      onPressed: () => setState(() => _isSignUp = !_isSignUp),
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(vertical: GudaSpacing.xs),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: _isSignUp ? '이미 계정이 있으신가요? ' : '처음이신가요? ',
                              style: GudaTypography.caption(
                                color: GudaColors.onSurfaceVariantLight,
                              ),
                            ),
                            TextSpan(
                              text: _isSignUp ? '로그인' : '회원가입',
                              style: GudaTypography.captionBold(
                                color: GudaColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).gudaFadeIn(delay: GudaDuration.slower),
                  SizedBox(height: constraints.maxHeight * 0.15),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
