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
import 'package:guda_chatbot/core/ui/widgets/guda_section_header.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_dialog.dart';
import 'package:guda_chatbot/features/auth/domain/entities/guda_user.dart';
import 'package:guda_chatbot/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:guda_chatbot/app/router/route_paths.dart';

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

    return ListView(
      children: [
        // ── 프로필 영역 ─────────────────────────
        if (user != null) ...[
          const GudaSectionHeader(title: AppStrings.profileSection),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: GudaSpacing.xl,
              vertical: GudaSpacing.md,
            ),
            child: Row(
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
                      Text(
                        user.displayName ?? AppStrings.userNamePlaceholder,
                        style: GudaTypography.heading3(color: colorScheme.onSurface),
                      ),
                      Text(
                        user.email,
                        style: GudaTypography.body2(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const GudaDivider(),
        ],

        // ── 앱 정보 ─────────────────────────────
        const GudaSectionHeader(title: AppStrings.appInfoSection),
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
        const GudaDivider(color: GudaColors.surfaceLight, alpha: 1.0),
        GudaTile(
          leading: const Icon(Icons.description_outlined),
          title: AppStrings.licenseLabel,
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
          onTap: () => context.push(RoutePaths.license),
        ),
        const GudaDivider(color: GudaColors.surfaceLight, alpha: 1.0),

        // ── 계정 관리 ─────────────────────────────
        const GudaSectionHeader(title: AppStrings.accountSection),
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
        const SizedBox(height: GudaSpacing.xxl),
      ],
    );
  }
}
