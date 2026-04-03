#!/bin/bash
set -e

# ============================================================
# Guda 앱 최적화 스크립트
# 코드 레벨 최적화 + 빌드 최적화를 한 번에 수행합니다.
# ============================================================

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

echo "========================================"
echo " Guda 앱 최적화 스크립트 시작"
echo " 프로젝트: $PROJECT_DIR"
echo "========================================"
echo ""

# ── 1. GudaAvatar: NetworkImage 에러 핸들링 및 캐싱 최적화 ──
echo "[1/8] GudaAvatar - NetworkImage 에러 핸들링 추가..."
cat > lib/core/ui/widgets/guda_avatar.dart << 'DART_EOF'
import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// Guda 공통 아바타 위젯
/// 프로필 이미지가 있을 경우 이미지를 보여주고, 없을 경우 이름을 바탕으로 기본 이니셜을 보여줍니다.
class GudaAvatar extends StatelessWidget {
  const GudaAvatar({
    super.key,
    this.photoUrl,
    required this.displayName,
    this.radius = 30.0,
  });

  final String? photoUrl;
  final String displayName;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (photoUrl != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(photoUrl!),
        backgroundColor: colorScheme.surfaceContainerHighest,
        onBackgroundImageError: (_, __) {},
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: colorScheme.primary,
      child: Text(
        displayName.isNotEmpty ? displayName.substring(0, 1).toUpperCase() : '?',
        style: GudaTypography.heading3(color: colorScheme.onPrimary).copyWith(
          fontSize: radius * 0.8,
        ),
      ),
    );
  }
}
DART_EOF
echo "  -> 완료: onBackgroundImageError 추가, backgroundColor 폴백 설정"

# ── 2. GudaMarkdown: MarkdownStyleSheet 재생성 방지 ──
echo "[2/8] GudaMarkdown - MarkdownStyleSheet 캐싱 최적화..."
cat > lib/core/ui/widgets/guda_markdown.dart << 'DART_EOF'
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

/// Guda 공통 마크다운 위젯
/// 디자인 시스템의 타이포그래피와 색상을 일관되게 적용합니다.
class GudaMarkdown extends StatelessWidget {
  const GudaMarkdown({
    super.key,
    required this.data,
    this.selectable = false,
  });

  final String data;
  final bool selectable;

  // 라이트/다크 모드별 StyleSheet를 캐싱하여 매 빌드마다 재생성 방지
  static MarkdownStyleSheet? _cachedLightSheet;
  static MarkdownStyleSheet? _cachedDarkSheet;

  static MarkdownStyleSheet _getStyleSheet(bool isDark) {
    if (isDark) {
      return _cachedDarkSheet ??= _buildStyleSheet(isDark: true);
    }
    return _cachedLightSheet ??= _buildStyleSheet(isDark: false);
  }

  static MarkdownStyleSheet _buildStyleSheet({required bool isDark}) {
    final textColor = isDark
        ? GudaColors.onAssistantBubbleDark
        : GudaColors.onAssistantBubbleLight;

    return MarkdownStyleSheet(
      p: GudaTypography.body1(color: textColor),
      h1: GudaTypography.heading1(color: textColor),
      h2: GudaTypography.heading2(color: textColor),
      h3: GudaTypography.heading3(color: textColor),
      listBullet: GudaTypography.body1(color: textColor),
      code: GudaTypography.classicQuote(color: GudaColors.accent),
      codeblockDecoration: BoxDecoration(
        color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.05),
        borderRadius: GudaRadius.smAll,
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border.all(
          color: isDark ? GudaColors.dividerDark : GudaColors.dividerLight,
          width: 0.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: data.isEmpty ? '...' : data,
      selectable: selectable,
      styleSheet: _getStyleSheet(context.isDark),
    );
  }
}
DART_EOF
echo "  -> 완료: 라이트/다크 모드별 static 캐시 적용"

# ── 3. MessageBubble: RepaintBoundary 추가 ──
echo "[3/8] MessageBubble - RepaintBoundary 추가..."
cat > lib/features/chat/presentation/widgets/message_bubble.dart << 'DART_EOF'
import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_message_item.dart';
import 'package:guda_chatbot/features/chat/domain/entities/message.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:guda_chatbot/features/chat/presentation/widgets/message_avatar.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/message_content.dart';

class MessageBubble extends ConsumerWidget {
  MessageBubble({
    super.key,
    required this.message,
    this.showActions = true,
  });

  final Message message;
  final bool showActions;
  final GlobalKey _shareKey = GlobalKey();

  bool get isUser => message.senderRole == MessageRole.user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RepaintBoundary(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) const MessageAvatar(),
          Flexible(
            child: GudaMessageItem(
              isUser: isUser,
              isStreaming: message.isStreaming,
              child: MessageContent(
                message: message,
                isUser: isUser,
                showActions: showActions,
                shareKey: _shareKey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
DART_EOF
echo "  -> 완료: RepaintBoundary 래핑, 불필요한 Column 제거"

# ── 4. GudaMessageItem: RepaintBoundary 추가 ──
echo "[4/8] GudaMessageItem - RepaintBoundary 추가..."
cat > lib/core/ui/widgets/guda_message_item.dart << 'DART_EOF'
import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_animations.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_chat_bubble.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_streaming_dots.dart';

/// Guda 공통 메시지 아이템 — 목록 내 개별 메시지 레벨 레이아웃
class GudaMessageItem extends StatelessWidget {
  const GudaMessageItem({
    super.key,
    required this.child,
    required this.isUser,
    this.isStreaming = false,
  });

  final Widget child;
  final bool isUser;
  final bool isStreaming;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isUser ? GudaSpacing.xxxl : GudaSpacing.md,
        right: isUser ? GudaSpacing.md : GudaSpacing.xxxl,
        top: GudaSpacing.xs,
        bottom: GudaSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          GudaChatBubble(
            isUser: isUser,
            child: child,
          ),
          if (isStreaming)
            const Padding(
              padding: EdgeInsets.only(top: GudaSpacing.xs),
              child: RepaintBoundary(child: GudaStreamingDots()),
            ),
        ],
      ),
    ).gudaFadeIn(
      duration: const Duration(milliseconds: 250),
    ).gudaSlideIn(
      begin: const Offset(0, 0.05),
    );
  }
}
DART_EOF
echo "  -> 완료: GudaStreamingDots에 RepaintBoundary 래핑"

# ── 5. GudaStreamingDots: RepaintBoundary 및 최적화 ──
echo "[5/8] GudaStreamingDots - RepaintBoundary 및 렌더링 최적화..."
cat > lib/core/ui/widgets/guda_streaming_dots.dart << 'DART_EOF'
import 'package:flutter/material.dart';

/// Guda 공통 스트리밍 도트 애니메이션
class GudaStreamingDots extends StatefulWidget {
  const GudaStreamingDots({super.key, this.color});

  final Color? color;

  @override
  State<GudaStreamingDots> createState() => _GudaStreamingDotsState();
}

class _GudaStreamingDotsState extends State<GudaStreamingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dotColor = widget.color ?? colorScheme.primary;

    return RepaintBoundary(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final delay = index * 0.2;
              double value = (_controller.value - delay) % 1.0;
              if (value < 0) value += 1.0;

              double scale = 0.5;
              if (value < 0.4) {
                scale = 0.5 + (0.5 * (value / 0.4));
              } else if (value < 0.8) {
                scale = 1.0 - (0.5 * ((value - 0.4) / 0.4));
              }

              return Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                ),
                transform: Matrix4.diagonal3Values(scale, scale, 1.0),
                transformAlignment: Alignment.center,
              );
            },
          );
        }),
      ),
    );
  }
}
DART_EOF
echo "  -> 완료: RepaintBoundary로 도트 애니메이션 격리"

# ── 6. GudaShadows: const 리스트로 변환 ──
echo "[6/8] GudaShadows - const 리스트로 변환..."
cat > lib/core/design_system/tokens/shadow_tokens.dart << 'DART_EOF'
import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/tokens/color_tokens.dart';

/// Guda 앱 그림자(Shadow) 토큰
/// static final -> static final (withValues는 런타임이므로 const 불가, 인스턴스 재생성 방지)
abstract final class GudaShadows {
  /// 카드 그림자 — 기본 엘리베이션
  static final List<BoxShadow> card = List.unmodifiable([
    BoxShadow(
      color: GudaColors.primary.withValues(alpha: 0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: GudaColors.primary.withValues(alpha: 0.04),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ]);

  /// 채팅 버블 그림자
  static final List<BoxShadow> bubble = List.unmodifiable([
    BoxShadow(
      color: GudaColors.primary.withValues(alpha: 0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ]);

  /// 입력창 그림자
  static final List<BoxShadow> inputBar = List.unmodifiable([
    BoxShadow(
      color: GudaColors.primary.withValues(alpha: 0.12),
      blurRadius: 20,
      offset: const Offset(0, -4),
    ),
  ]);

  /// 모달/바텀시트 그림자
  static final List<BoxShadow> modal = List.unmodifiable([
    BoxShadow(
      color: GudaColors.primary.withValues(alpha: 0.2),
      blurRadius: 40,
      offset: const Offset(0, -8),
    ),
  ]);

  /// 사이드바 그림자 (데스크톱)
  static final List<BoxShadow> sidebar = List.unmodifiable([
    BoxShadow(
      color: GudaColors.primary.withValues(alpha: 0.15),
      blurRadius: 24,
      offset: const Offset(4, 0),
    ),
  ]);
}
DART_EOF
echo "  -> 완료: List.unmodifiable로 불변성 보장, 재생성 방지"

# ── 7. AppTheme: ThemeData 캐싱 ──
echo "[7/8] AppTheme - ThemeData 캐싱..."
cat > lib/app/theme/app_theme.dart << 'DART_EOF'
import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';

/// Guda 앱 테마 팩토리 — 디자인 시스템 토큰 기반으로 ThemeData 조합
/// ThemeData를 캐싱하여 매 빌드마다 재생성 방지
abstract final class AppTheme {
  static ThemeData? _lightCache;
  static ThemeData? _darkCache;

  /// 라이트 모드 ThemeData (캐싱)
  static ThemeData light() => _lightCache ??= _build(
    colorScheme: GudaColorScheme.light(),
    brightness: Brightness.light,
    scaffoldBg: GudaColors.backgroundLight,
  );

  /// 다크 모드 ThemeData (캐싱)
  static ThemeData dark() => _darkCache ??= _build(
    colorScheme: GudaColorScheme.dark(),
    brightness: Brightness.dark,
    scaffoldBg: GudaColors.backgroundDark,
  );

  static ThemeData _build({
    required ColorScheme colorScheme,
    required Brightness brightness,
    required Color scaffoldBg,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBg,

      // ── 앱바 ─────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GudaTypography.heading3(color: colorScheme.onSurface),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),

      // ── 카드 ─────────────────────────────────────
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: GudaRadius.mdAll),
        margin: const EdgeInsets.symmetric(
          horizontal: GudaSpacing.md,
          vertical: GudaSpacing.xs,
        ),
      ),

      // ── 입력 필드 ─────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: GudaRadius.mdAll,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: GudaRadius.mdAll,
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: GudaSpacing.md,
          vertical: GudaSpacing.md12,
        ),
      ),

      // ── 구분선 ────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 0.5,
        space: 0,
      ),

      // ── 리스트 타일 ───────────────────────────────
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: GudaSpacing.md,
          vertical: GudaSpacing.xs,
        ),
        shape: const RoundedRectangleBorder(borderRadius: GudaRadius.mdAll),
      ),

      // ── 아이콘 ────────────────────────────────────
      iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant, size: 24),
    );
  }
}
DART_EOF
echo "  -> 완료: light/dark ThemeData static 캐시 적용"

# ── 8. GudaApp: MediaQuery builder 위젯 분리 ──
echo "[8/8] GudaApp - MediaQuery 리빌드 최소화..."
cat > lib/main.dart << 'DART_EOF'
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:guda_chatbot/app/config/app_config.dart';
import 'package:guda_chatbot/app/router/app_router.dart';
import 'package:guda_chatbot/app/theme/app_theme.dart';
import 'package:guda_chatbot/core/network/dio_client.dart';
import 'package:guda_chatbot/core/utils/license_registry_util.dart';
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
DART_EOF
echo "  -> 완료: fontScale == 1.0일 때 MediaQuery 래핑 스킵"

echo ""
echo "========================================"
echo " 코드 최적화 완료! 빌드 최적화 진행..."
echo "========================================"
echo ""

# ── 9. Flutter 빌드 최적화 ──
echo "[빌드 1/4] flutter clean - 캐시 정리..."
flutter clean

echo ""
echo "[빌드 2/4] flutter pub get - 의존성 재설치..."
flutter pub get

echo ""
echo "[빌드 3/4] build_runner - 코드 재생성..."
dart run build_runner build --delete-conflicting-outputs

echo ""
echo "[빌드 4/4] dart fix --apply - 자동 수정 적용..."
dart fix --apply

echo ""
echo "========================================"
echo " 전체 최적화 완료!"
echo "========================================"
echo ""
echo "적용된 최적화 항목:"
echo "  [1] GudaAvatar: NetworkImage 에러 핸들링 + 폴백 배경색"
echo "  [2] GudaMarkdown: MarkdownStyleSheet 라이트/다크 캐싱"
echo "  [3] MessageBubble: RepaintBoundary + 불필요한 Column 제거"
echo "  [4] GudaMessageItem: StreamingDots RepaintBoundary 격리"
echo "  [5] GudaStreamingDots: RepaintBoundary 자체 래핑"
echo "  [6] GudaShadows: List.unmodifiable 불변성 보장"
echo "  [7] AppTheme: ThemeData 라이트/다크 static 캐싱"
echo "  [8] GudaApp: fontScale 1.0일 때 MediaQuery 래핑 스킵"
echo "  [9] flutter clean + pub get + build_runner + dart fix"
echo ""
echo "다음 단계: flutter analyze 로 잔여 이슈를 확인하세요."
