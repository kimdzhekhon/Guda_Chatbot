import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/features/auth/domain/entities/guda_user.dart';
import 'package:guda_chatbot/features/auth/presentation/screens/auth_screen.dart';
import 'package:guda_chatbot/features/auth/presentation/screens/splash_screen.dart';
import 'package:guda_chatbot/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:guda_chatbot/features/chat/presentation/screens/home_screen.dart';
import 'package:guda_chatbot/features/settings/presentation/screens/settings_screen.dart';
import 'package:guda_chatbot/features/settings/presentation/screens/license_screen.dart';
import 'package:guda_chatbot/features/settings/presentation/screens/font_size_screen.dart';
import 'route_paths.dart';

part 'app_router.g.dart';

/// AppRouter — go_router 기반 싱글 라우터
@riverpod
GoRouter appRouter(Ref ref) {
  final router = GoRouter(
    initialLocation: RoutePaths.splash,
    redirect: (context, state) {
      final authState = ref.read(authViewModelProvider);
      final isSplash = state.matchedLocation == RoutePaths.splash;
      final isAuth = state.matchedLocation == RoutePaths.auth;

      // 로딩 중에는 스플래시 유지
      if (authState is UiLoading) {
        if (isAuth) return null; // 로그인 화면에서 로딩 중일 때는 화면 유지 (버튼 안의 스피너만 동작)
        return isSplash ? null : RoutePaths.splash;
      }

      final isLoggedIn =
          authState is UiSuccess<GudaUser?> && authState.data != null;

      // 미인증 시 로그인 화면으로
      if (!isLoggedIn && !isAuth) return RoutePaths.auth;

      // 인증 완료 시 인증/스플래시 화면에서 홈으로
      if (isLoggedIn && (isAuth || isSplash)) return RoutePaths.chatList;

      return null;
    },
    routes: [
      GoRoute(path: RoutePaths.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: RoutePaths.auth, builder: (_, _) => const AuthScreen()),
      GoRoute(path: RoutePaths.chatList, builder: (_, _) => const HomeScreen()),
      GoRoute(
        path: RoutePaths.settings,
        builder: (_, _) => const SettingsScreen(),
      ),
      GoRoute(
        path: RoutePaths.license,
        builder: (_, _) => const LicenseScreen(),
      ),
      GoRoute(
        path: RoutePaths.fontSize,
        builder: (_, _) => const FontSizeScreen(),
      ),
    ],
  );

  // Auth 상태가 바뀔 때마다 redirect 로직 재평가
  ref.listen(authViewModelProvider, (_, _) => router.refresh());

  return router;
}
