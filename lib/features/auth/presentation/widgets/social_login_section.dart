import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_social_button.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_terms_bottom_sheet.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';
import 'package:guda_chatbot/features/auth/presentation/viewmodels/auth_viewmodel.dart';

class SocialLoginSection extends ConsumerWidget {
  const SocialLoginSection({
    super.key,
    required this.isSignUp,
    required this.isLoading,
  });

  final bool isSignUp;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: context.colorScheme.outlineVariant,
                thickness: 0.5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: GudaSpacing.md),
              child: Text(
                '또는',
                style: GudaTypography.caption2(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: context.colorScheme.outlineVariant,
                thickness: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: GudaSpacing.md),
        GudaSocialButton(
          onPressed: () async {
            bool agreed = true;
            if (isSignUp) {
              agreed = await GudaTermsBottomSheet.show(context) ?? false;
            }
            if (agreed) {
              ref.read(authViewModelProvider.notifier).signInWithGoogle();
            }
          },
          isLoading: isLoading,
          provider: GudaSocialProvider.google,
          height: 48,
        ),
        const SizedBox(height: GudaSpacing.md),
        GudaSocialButton(
          onPressed: () async {
            bool agreed = true;
            if (isSignUp) {
              agreed = await GudaTermsBottomSheet.show(context) ?? false;
            }
            if (agreed) {
              ref.read(authViewModelProvider.notifier).signInWithApple();
            }
          },
          isLoading: isLoading,
          provider: GudaSocialProvider.apple,
          height: 48,
        ),
      ],
    );
  }
}
