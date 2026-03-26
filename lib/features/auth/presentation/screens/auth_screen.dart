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
import 'package:guda_chatbot/features/auth/presentation/widgets/auth_form_card.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
      body: _buildContent(isLoading),
    );
  }

  Widget _buildContent(bool isLoading) {
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
                const AuthBranding(),
                if (!isKeyboardOpen) const Spacer(flex: 1),
                const SizedBox(height: GudaSpacing.md),
                
                AuthFormCard(
                  isLoading: isLoading,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  onEmailAuth: (isSignUp) => _handleEmailAuth(isSignUp),
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
  }

  void _handleEmailAuth(bool isSignUp) {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) return;

    if (isSignUp) {
      ref.read(authViewModelProvider.notifier).signUpWithEmail(email, password);
    } else {
      ref.read(authViewModelProvider.notifier).signInWithEmail(email, password);
    }
  }
}
