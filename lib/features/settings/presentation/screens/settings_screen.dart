import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_lottie.dart';
import 'package:guda_chatbot/core/constants/app_assets.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/ui/layout/app_responsive_layout.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_tile.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_divider.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_app_bar.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_section.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_dialog.dart';
import 'package:guda_chatbot/features/auth/domain/entities/guda_user.dart';
import 'package:guda_chatbot/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:guda_chatbot/app/router/route_paths.dart';
import 'package:guda_chatbot/app/theme/theme_viewmodel.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_usage_viewmodel.dart';

/// SCR_SETTINGS — 설정 화면
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = switch (authState) {
      UiSuccess<GudaUser?>(data: final u) => u,
      _ => null,
    };

    return Scaffold(
      appBar: const GudaAppBar(title: AppStrings.settingLabel),
      body: AppResponsiveLayout(
        mobile: (context, data) => _buildBody(context, user, ref),
        tablet: (context, data) => Center(
          child: SizedBox(
            width: 600,
            child: _buildBody(context, user, ref),
          ),
        ),
        desktop: (context, data) => Center(
          child: SizedBox(
            width: 800,
            child: _buildBody(context, user, ref),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    GudaUser? user,
    WidgetRef ref,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final usage = ref.watch(chatUsageViewModelProvider);
    final progress = usage.totalLimit > 0 ? usage.usedCount / usage.totalLimit : 0.0;

    return ListView(
      children: [
        // ── 프로필 영역 ─────────────────────────
        if (user != null)
          GudaSection(
            title: AppStrings.profileSection,
            child: Container(
              padding: const EdgeInsets.all(GudaSpacing.lg),
              decoration: BoxDecoration(
                color: isDark ? GudaColors.surfaceDark : GudaColors.surfaceLight,
                borderRadius: GudaRadius.lgAll,
                boxShadow: GudaShadows.card,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GudaLottie(
                    path: AppAssets.lotusLottie,
                    size: 60,
                  ),
                  const SizedBox(width: GudaSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: GudaSpacing.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: GudaRadius.smAll,
                          ),
                          child: Text(
                            usage.planName,
                            style: GudaTypography.captionBold(color: colorScheme.primary),
                          ),
                        ),
                        const SizedBox(height: GudaSpacing.xs),
                        Text(
                          user.email,
                          style: GudaTypography.heading3(color: colorScheme.onSurface),
                        ),
                        const SizedBox(height: GudaSpacing.md),
                        ClipRRect(
                          borderRadius: GudaRadius.smAll,
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor:
                                isDark ? GudaColors.dividerDark : GudaColors.dividerLight,
                            color: GudaColors.accent,
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: GudaSpacing.xs),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '대화 사용량',
                              style: GudaTypography.tiny(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              '${usage.usedCount} / ${usage.totalLimit}',
                              style: GudaTypography.tiny(
                                color: colorScheme.onSurfaceVariant,
                              ).copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

        // ── 결제 및 이용 ───────────────────────────
        GudaSection(
          title: AppStrings.billingSection,
          headerPadding: const EdgeInsets.fromLTRB(
            GudaSpacing.xl,
            GudaSpacing.md,
            GudaSpacing.xl,
            GudaSpacing.sm,
          ),
          contentPadding: EdgeInsets.zero,
          child: Column(
            children: [
              GudaTile(
                leading: const Icon(Icons.receipt_long_rounded),
                title: AppStrings.purchaseHistoryLabel,
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('준비 중인 기능입니다.')),
                  );
                },
              ),
              const GudaDivider(alpha: 1.0),
              GudaTile(
                leading: const Icon(Icons.history_rounded),
                title: AppStrings.usageHistoryLabel,
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('준비 중인 기능입니다.')),
                  );
                },
              ),
            ],
          ),
        ),

        // ── 앱 설정 ─────────────────────────────
        GudaSection(
          title: AppStrings.appSettingsSection,
          contentPadding: EdgeInsets.zero,
          child: Column(
            children: [
              GudaTile(
                leading: const Icon(Icons.text_format_rounded),
                title: AppStrings.fontSizeLabel,
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                ),
                onTap: () => context.push(RoutePaths.fontSize),
              ),
              const GudaDivider(alpha: 1.0),
              GudaTile(
                leading: const Icon(Icons.bookmark_outline_rounded),
                title: '보관함',
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                ),
                onTap: () => context.push(RoutePaths.bookmarks),
              ),
              const GudaDivider(alpha: 1.0),
              _ThemeSelectionTile(),
            ],
          ),
        ),

        // ── 앱 정보 ─────────────────────────────
        GudaSection(
          title: AppStrings.appInfoSection,
          contentPadding: EdgeInsets.zero,
          child: Column(
            children: [
              GudaTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: AppStrings.appVersionLabel,
                trailing: Text(
                  AppStrings.version.split(' ').last,
                  style: GudaTypography.caption(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ),
              ),
              const GudaDivider(alpha: 1.0),
              GudaTile(
                leading: const Icon(Icons.description_outlined),
                title: AppStrings.licenseLabel,
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                ),
                onTap: () => context.push(RoutePaths.license),
              ),
            ],
          ),
        ),

        GudaSection(
          title: AppStrings.accountSection,
          contentPadding: EdgeInsets.zero,
          child: Column(
            children: [
              GudaTile(
                leading: Icon(Icons.logout_rounded, color: colorScheme.error),
                title: AppStrings.logoutConfirmTitle,
                color: colorScheme.error,
                onTap: () async {
                  final confirm = await GudaDialog.show(
                    context,
                    title: AppStrings.logoutConfirmTitle,
                    content: AppStrings.logoutConfirmMessage,
                    confirmLabel: AppStrings.logoutConfirmTitle,
                    isDestructive: true,
                  );
                  if (confirm == true && context.mounted) {
                    await ref.read(authViewModelProvider.notifier).signOut();
                  }
                },
              ),
              const GudaDivider(alpha: 1.0),
              GudaTile(
                leading: Icon(Icons.person_remove_outlined, color: colorScheme.error),
                title: AppStrings.deleteAccountConfirmTitle,
                color: colorScheme.error,
                onTap: () async {
                  final confirm = await GudaDialog.show(
                    context,
                    title: AppStrings.deleteAccountConfirmTitle,
                    content: AppStrings.deleteAccountConfirmMessage,
                    confirmLabel: AppStrings.deleteAccountConfirmTitle,
                    isDestructive: true,
                  );
                  if (confirm == true && context.mounted) {
                    await ref.read(authViewModelProvider.notifier).deleteAccount();
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: GudaSpacing.xxl),
      ],
    );
  }
}

class _ThemeSelectionTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeViewModelProvider);
    final colorScheme = Theme.of(context).colorScheme;

    final currentMode = themeMode.maybeWhen(
      data: (mode) => mode,
      orElse: () => ThemeMode.system,
    );

    final modeLabel = switch (currentMode) {
      ThemeMode.system => AppStrings.systemThemeLabel,
      ThemeMode.light => AppStrings.lightThemeLabel,
      ThemeMode.dark => AppStrings.darkThemeLabel,
    };

    return GudaTile(
      leading: Icon(
        currentMode == ThemeMode.dark
            ? Icons.dark_mode_rounded
            : Icons.light_mode_rounded,
      ),
      title: AppStrings.themeLabel,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            modeLabel,
            style: GudaTypography.caption(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ).copyWith(height: 1.3),
          ),
          const SizedBox(width: GudaSpacing.xs),
          Icon(
            Icons.chevron_right_rounded,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
        ],
      ),
      onTap: () => _showThemeSelectionDialog(context, ref, currentMode),
    );
  }

  void _showThemeSelectionDialog(
    BuildContext context,
    WidgetRef ref,
    ThemeMode currentMode,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    GudaDialog.show(
      context,
      title: AppStrings.themeLabel,
      contentWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GudaTile(
            title: AppStrings.systemThemeLabel,
            isSelected: currentMode == ThemeMode.system,
            onTap: () {
              ref.read(themeViewModelProvider.notifier).setThemeMode(ThemeMode.system);
              Navigator.pop(context);
            },
            trailing: currentMode == ThemeMode.system
                ? Icon(Icons.check_rounded, color: colorScheme.primary)
                : null,
          ),
          GudaTile(
            title: AppStrings.lightThemeLabel,
            isSelected: currentMode == ThemeMode.light,
            onTap: () {
              ref.read(themeViewModelProvider.notifier).setThemeMode(ThemeMode.light);
              Navigator.pop(context);
            },
            trailing: currentMode == ThemeMode.light
                ? Icon(Icons.check_rounded, color: colorScheme.primary)
                : null,
          ),
          GudaTile(
            title: AppStrings.darkThemeLabel,
            isSelected: currentMode == ThemeMode.dark,
            onTap: () {
              ref.read(themeViewModelProvider.notifier).setThemeMode(ThemeMode.dark);
              Navigator.pop(context);
            },
            trailing: currentMode == ThemeMode.dark
                ? Icon(Icons.check_rounded, color: colorScheme.primary)
                : null,
          ),
        ],
      ),
      showConfirm: false,
      cancelLabel: AppStrings.closeLabel,
    );
  }
}

