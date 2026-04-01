import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/features/auth/domain/entities/guda_user.dart';
import 'package:guda_chatbot/features/auth/presentation/screens/auth_screen.dart';
import 'package:guda_chatbot/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:guda_chatbot/features/auth/presentation/screens/splash_screen.dart';
import 'package:guda_chatbot/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:guda_chatbot/features/chat/presentation/screens/home_screen.dart';
import 'package:guda_chatbot/features/settings/presentation/screens/settings_screen.dart';
import 'package:guda_chatbot/features/settings/presentation/screens/license_screen.dart';
import 'package:guda_chatbot/features/settings/presentation/screens/font_size_screen.dart';
import 'package:guda_chatbot/features/settings/presentation/screens/persona_selection_screen.dart';
import 'package:guda_chatbot/features/bookmarks/presentation/screens/bookmark_screen.dart';
import 'package:guda_chatbot/features/settings/presentation/screens/notice_screen.dart';
import 'route_paths.dart';

part 'app_router.g.dart';

/// AppRouter — go_router 기반 싱글 라우터
@riverpod
GoRouter appRouter(Ref ref) {
  final router = GoRouter(
    initialLocation: RoutePaths.splash,
    redirect: (context, state) {
      final authState = ref.read(authViewModelProvider);
      final matchedLocation = state.matchedLocation;
      final isSplash = matchedLocation == RoutePaths.splash;
      final isAuth = matchedLocation == RoutePaths.auth;
      final isOnboarding = matchedLocation == RoutePaths.onboarding;

      // 로딩 중에는 기존 화면 유지 (Auth, Onboarding) 혹은 스플래시로
      if (authState is UiLoading) {
        if (isSplash || isAuth || isOnboarding) return null;
        return RoutePaths.splash;
      }

      // 에러 시에는 현재 화면에서 오류를 표시할 수 있도록 리다이렉션 방지
      if (authState is UiError) {
        if (isAuth || isOnboarding) return null;
        return RoutePaths.auth;
      }

      final user = authState is UiSuccess<GudaUser?> ? authState.data : null;
      final isLoggedIn = user != null;

      // 미인증 시 로그인 화면으로
      if (!isLoggedIn) {
        if (isAuth) return null;
        return RoutePaths.auth;
      }

      // 인증 완료 시 상태 체크
      if (isLoggedIn) {
        // 프로필 미완성 시 온보딩으로 (이미 온보딩 화면이면 유지)
        if (!user.isProfileComplete) {
          if (isOnboarding) return null;
          return RoutePaths.onboarding;
        }
        
        // 인증/스플래시/온보딩 화면에서 로그인 된 상태면 홈(채팅 목록)으로 이동
        // 그 외의 화면(설정, 다이얼로그 등)에서는 현재 위치를 절대 바꾸지 않음
        if (isAuth || isSplash || isOnboarding) {
          return RoutePaths.chatList;
        }
      }

      return null;
    },
    routes: [
      GoRoute(path: RoutePaths.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: RoutePaths.auth, builder: (_, _) => const AuthScreen()),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (_, _) => const OnboardingScreen(),
      ),
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
      GoRoute(
        path: RoutePaths.persona,
        builder: (_, _) => const PersonaSelectionScreen(),
      ),
      GoRoute(
        path: RoutePaths.bookmarks,
        builder: (_, _) => const BookmarkScreen(),
      ),
      GoRoute(
        path: RoutePaths.notice,
        builder: (_, _) => const NoticeScreen(),
      ),
    ],
  );

  // Auth 상태가 바뀔 때마다 redirect 로직 재평가
  ref.listen(authViewModelProvider, (_, _) => router.refresh());

  return router;
}
