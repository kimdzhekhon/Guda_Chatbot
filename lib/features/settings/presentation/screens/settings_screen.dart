import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_scaffold.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_section.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_tile.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_divider.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_app_bar.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_dialog.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/features/auth/domain/entities/guda_user.dart';
import 'package:guda_chatbot/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/chat_usage_viewmodel.dart';
import 'package:guda_chatbot/app/router/route_paths.dart';
import 'package:guda_chatbot/app/theme/theme_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:guda_chatbot/features/settings/presentation/widgets/user_profile_card.dart';
import 'package:guda_chatbot/features/chat/domain/entities/persona_type.dart';
import 'package:guda_chatbot/features/settings/presentation/viewmodels/persona_viewmodel.dart';

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

    return GudaScaffold(
      appBar: const GudaAppBar(title: AppStrings.settingLabel),
      body: _buildBody(context, user, ref),
    );
  }

  Widget _buildBody(
    BuildContext context,
    GudaUser? user,
    WidgetRef ref,
  ) {
    final usage = ref.watch(chatUsageViewModelProvider);
    final isUsageLoaded = usage.totalLimit > 0;
    final progress = isUsageLoaded ? usage.usedCount / usage.totalLimit : 0.0;

    return ListView(
      children: [
        // ── 프로필 영역 ─────────────────────────
        if (user != null)
          GudaSection(
            title: AppStrings.profileSection,
            child: UserProfileCard(
              user: user,
              usage: isUsageLoaded ? usage : null,
              progress: progress,
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
                  color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
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
                  color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
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
                  color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                ),
                onTap: () => context.push(RoutePaths.fontSize),
              ),
              const GudaDivider(alpha: 1.0),
              _PersonaSelectionTile(),
              const GudaDivider(alpha: 1.0),
              GudaTile(
                leading: const Icon(Icons.bookmark_outline_rounded),
                title: '보관함',
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
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
                trailing: Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    AppStrings.version.split(' ').last,
                    style: GudaTypography.caption(
                      color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    ).copyWith(height: 1.2),
                  ),
                ),
              ),
              const GudaDivider(alpha: 1.0),
              GudaTile(
                leading: const Icon(Icons.description_outlined),
                title: AppStrings.licenseLabel,
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
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
                leading: Icon(Icons.logout_rounded, color: context.colorScheme.error),
                title: AppStrings.logoutConfirmTitle,
                color: context.colorScheme.error,
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
                leading: Icon(Icons.person_remove_outlined, color: context.colorScheme.error),
                title: AppStrings.deleteAccountConfirmTitle,
                color: context.colorScheme.error,
                onTap: () async {
                  final confirm = await GudaDialog.show(
                    context,
                    title: AppStrings.deleteAccountConfirmTitle,
                    content: AppStrings.deleteAccountConfirmMessage,
                    confirmLabel: AppStrings.deleteAccountConfirmTitle,
                    isDestructive: true,
                  );
                  if (confirm == true && context.mounted) {
                    // 전체 화면 로딩 오버레이 표시
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      barrierColor: Colors.black.withValues(alpha: 0.8),
                      builder: (_) => const PopScope(
                        canPop: false,
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                    );
                    await ref.read(authViewModelProvider.notifier).deleteAccount();
                    // 탈퇴 성공 시 라우터가 auth로 리다이렉트하므로 다이얼로그 수동 닫기 불필요
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

class _PersonaSelectionTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personaState = ref.watch(personaProvider);
    final personaNotifier = ref.read(personaProvider.notifier);

    final currentId = personaState.dataOrNull ?? PersonaType.basic;

    final persona = personaNotifier.personas.firstWhere(
      (p) => p.id == currentId,
      orElse: () => personaNotifier.personas.first,
    );

    return GudaTile(
      leading: const Icon(Icons.psychology_outlined),
      title: AppStrings.personaSettingTitle,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              persona.name.split(' ').first, // '기본' 또는 '친절한' 등 앞단어만 표시
              style: GudaTypography.caption(
                color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ).copyWith(height: 1.2),
            ),
          ),
          const SizedBox(width: GudaSpacing.xs),
          Icon(
            Icons.chevron_right_rounded,
            color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
        ],
      ),
      onTap: () => context.push(RoutePaths.persona),
    );
  }
}

class _ThemeSelectionTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeViewModelProvider);

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
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              modeLabel,
              style: GudaTypography.caption(
                color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ).copyWith(height: 1.2),
            ),
          ),
          const SizedBox(width: GudaSpacing.xs),
          Icon(
            Icons.chevron_right_rounded,
            color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
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
                ? Icon(Icons.check_rounded, color: context.colorScheme.primary)
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
                ? Icon(Icons.check_rounded, color: context.colorScheme.primary)
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
                ? Icon(Icons.check_rounded, color: context.colorScheme.primary)
                : null,
          ),
        ],
      ),
      showConfirm: false,
      cancelLabel: AppStrings.closeLabel,
    );
  }
}
