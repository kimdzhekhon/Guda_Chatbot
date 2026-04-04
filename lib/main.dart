import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:guda_chatbot/app/config/app_config.dart';
import 'package:guda_chatbot/app/router/app_router.dart';
import 'package:guda_chatbot/app/theme/app_theme.dart';
import 'package:guda_chatbot/core/network/dio_client.dart';
import 'package:guda_chatbot/core/network/rpc_invoker.dart';
import 'package:guda_chatbot/core/utils/license_registry_util.dart';
import 'package:guda_chatbot/features/chat/data/datasources/supabase_chat_datasource.dart';
import 'package:guda_chatbot/features/settings/presentation/viewmodels/font_size_viewmodel.dart';
import 'package:guda_chatbot/app/theme/theme_viewmodel.dart';

/// 앱 부트스트랩 — Supabase, Dio 초기화 후 runApp 호출
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 0. 라이선스 등록
  LicenseRegistryUtil.init();

  // 1. Supabase 초기화
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  // 2. Dio 클라이언트 초기화
  DioClient.instance.initialize(baseUrl: AppConfig.supabaseUrl);

  // 3. [임시] 임베딩 디버그 테스트 — 로그인 상태일 때 자동 실행
  if (kDebugMode) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      SupabaseChatDataSource(SupabaseRpcInvoker())
          .debugTestEmbedding('건괘의 의미를 알려주세요')
          .catchError((e) => debugPrint('[Embedding Debug Error] $e'));
    } else {
      debugPrint('[Embedding Debug] 로그인 필요 — 로그인 후 앱 재시작하면 테스트 실행됨');
    }
  }

  // 3. ProviderScope로 앱 실행
  runApp(const ProviderScope(child: GudaApp()));
}

/// GudaApp — 루트 위젯
class GudaApp extends ConsumerWidget {
  const GudaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final fontScale = ref.watch(fontSizeViewModelProvider);
    final themeMode = ref.watch(themeViewModelProvider);

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode.maybeWhen(
        data: (mode) => mode,
        orElse: () => ThemeMode.system,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      locale: const Locale('ko', 'KR'),
      routerConfig: router,
      builder: (context, child) {
        final scale = fontScale.maybeWhen(
          data: (scale) => scale,
          orElse: () => 1.0,
        );
        // scale이 기본값(1.0)이면 MediaQuery 래핑 자체를 건너뛰어 리빌드 비용 절감
        if (scale == 1.0) return child!;
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(scale),
          ),
          child: child!,
        );
      },
    );
  }
}
