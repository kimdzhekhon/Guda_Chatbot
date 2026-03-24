import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/features/auth/presentation/viewmodels/auth_viewmodel.dart';

/// SCR_SPLASH — 스플래시 화면
/// 앱 진입 후 세션 자동 확인 후 적절한 화면으로 라우팅
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 프레임 렌더링 후 세션 확인
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authViewModelProvider.notifier).checkSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: GudaColors.backgroundLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 연꽃 아이콘 (임시 아이콘)
            Image.asset(
              'assets/images/app_logo_transparent.png',
              width: 100,
              height: 100,
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: GudaSpacing.lg),
            Text(
              'G u d a',
              style: GudaTypography.brand(color: colorScheme.primary),
            ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
            const SizedBox(height: GudaSpacing.sm),
            Text(
              '동양 고전의 지혜를 만나다',
              style: GudaTypography.body2(color: colorScheme.onSurfaceVariant),
            ).animate().fadeIn(delay: 500.ms, duration: 500.ms),
          ],
        ),
      ),
    );
  }
}
