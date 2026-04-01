import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_social_button.dart';
import 'package:guda_chatbot/features/auth/presentation/viewmodels/auth_viewmodel.dart';
 
class SocialLoginSection extends ConsumerWidget {
  const SocialLoginSection({
    super.key,
    required this.isSignUp,
    required this.isLoading,
    this.nickname,
    this.birthDate,
    this.persona,
  });
 
  final bool isSignUp;
  final bool isLoading;
  final String? nickname;
  final DateTime? birthDate;
  final String? persona;
 
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        GudaSocialButton(
          onPressed: () => _handleSocialLogin(context, ref, isGoogle: true),
          provider: GudaSocialProvider.google,
          isLoading: isLoading,
        ),
        const SizedBox(height: GudaSpacing.md),
        GudaSocialButton(
          onPressed: () => _handleSocialLogin(context, ref, isGoogle: false),
          provider: GudaSocialProvider.apple,
          isLoading: isLoading,
        ),
      ],
    );
  }

  Future<void> _handleSocialLogin(BuildContext context, WidgetRef ref,
      {required bool isGoogle}) async {
    // 이제 온보딩 플로우는 로그인 후 AppRouter에서 리다이렉션으로 제어하므로,
    // 이곳에서는 회원가입 전용 정보를 사전에 체크하지 않고 바로 소셜 로그인을 시도합니다.
    
    if (isGoogle) {
      await ref.read(authViewModelProvider.notifier).signInWithGoogle(
            isSignUp: false, // 이제 true일 때 직접 가입 처리를 여기서 하지 않음
          );
    } else {
      await ref.read(authViewModelProvider.notifier).signInWithApple(
            isSignUp: false,
          );
    }
  }
}
