import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_social_button.dart';
import 'package:guda_chatbot/features/auth/presentation/viewmodels/auth_viewmodel.dart';

class SocialLoginSection extends ConsumerWidget {
  const SocialLoginSection({
    super.key,
    required this.isLoading,
  });

  final bool isLoading;

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
    if (isGoogle) {
      await ref.read(authViewModelProvider.notifier).signInWithGoogle();
    } else {
      await ref.read(authViewModelProvider.notifier).signInWithApple();
    }
  }
}
