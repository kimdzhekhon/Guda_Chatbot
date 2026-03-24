import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:guda_chatbot/app/config/app_config.dart';
import 'package:guda_chatbot/app/router/app_router.dart';
import 'package:guda_chatbot/app/theme/app_theme.dart';
import 'package:guda_chatbot/core/network/dio_client.dart';

/// 앱 부트스트랩 — Supabase, Dio 초기화 후 runApp 호출
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Supabase 초기화
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  // 2. Dio 클라이언트 초기화
  DioClient.instance.initialize(baseUrl: AppConfig.supabaseUrl);

  // 3. ProviderScope로 앱 실행
  runApp(const ProviderScope(child: GudaApp()));
}

/// GudaApp — 루트 위젯
class GudaApp extends ConsumerWidget {
  const GudaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
