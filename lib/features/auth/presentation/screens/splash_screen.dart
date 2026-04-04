import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_animations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/constants/app_assets.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_scaffold.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';
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
    return GudaScaffold(
      useSafeArea: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 연꽃 아이콘 (임시 아이콘)
            Image.asset(
              AppAssets.appLogoTransparent,
              width: 100,
              height: 100,
            ).gudaScaleIn(duration: GudaDuration.slower, curve: Curves.elasticOut),
            const SizedBox(height: GudaSpacing.lg),
            Text(
              AppStrings.brandName,
              style: GudaTypography.brand(color: context.primaryColor),
            ).gudaScaleIn(duration: GudaDuration.slower, curve: Curves.elasticOut),
            const SizedBox(height: GudaSpacing.sm),
            Text(
              AppStrings.splashMessage,
              style: GudaTypography.body2(
                color: context.onSurfaceVariantColor,
              ),
            ).gudaFadeIn(delay: GudaDuration.slow, duration: GudaDuration.slow),
          ],
        ),
      ),
    );
  }
}
