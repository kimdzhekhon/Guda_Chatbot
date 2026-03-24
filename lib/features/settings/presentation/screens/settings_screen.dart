import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/core/ui/layout/app_responsive_layout.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/ui_state.dart';
import 'package:guda_chatbot/features/auth/domain/entities/guda_user.dart';
import 'package:guda_chatbot/features/auth/presentation/viewmodels/auth_viewmodel.dart';

/// SCR_SETTINGS — 설정 화면
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authViewModelProvider);
    final user = switch (authState) {
      UiSuccess<GudaUser?>(data: final u) => u,
      _ => null,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: AppResponsiveLayout(
        mobile: (context, data) => _buildBody(context, colorScheme, user, ref),
        tablet: (context, data) => Center(
          child: SizedBox(
            width: 600,
            child: _buildBody(context, colorScheme, user, ref),
          ),
        ),
        desktop: (context, data) => Center(
          child: SizedBox(
            width: 800,
            child: _buildBody(context, colorScheme, user, ref),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ColorScheme colorScheme,
    GudaUser? user,
    WidgetRef ref,
  ) {
    return ListView(
      children: [
        // ── 프로필 영역 ─────────────────────────
        if (user != null) ...[
          Padding(
            padding: const EdgeInsets.all(GudaSpacing.xl),
            child: Row(
              children: [
                if (user.photoUrl != null)
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(user.photoUrl!),
                  )
                else
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: colorScheme.primary,
                    child: Text(
                      user.displayName?.substring(0, 1).toUpperCase() ?? '?',
                      style: GudaTypography.heading3(color: colorScheme.onPrimary),
                    ),
                  ),
                const SizedBox(width: GudaSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName ?? '이름 없음',
                      style: GudaTypography.heading3(color: colorScheme.onSurface),
                    ),
                    Text(
                      user.email,
                      style: GudaTypography.body2(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
        ],

        // ── 앱 정보 ─────────────────────────────
        ListTile(
          leading: const Icon(Icons.info_outline_rounded),
          title: Text('버전', style: GudaTypography.body1()),
          trailing: Text('1.0.0', style: GudaTypography.body2()),
        ),
        ListTile(
          leading: const Icon(Icons.menu_book_rounded),
          title: Text('수록 경전', style: GudaTypography.body1()),
          subtitle: Text(
            '팔만대장경 · 주역 · 구사론',
            style: GudaTypography.body2(color: colorScheme.onSurfaceVariant),
          ),
        ),

        const Divider(),

        // ── 로그아웃 ─────────────────────────────
        ListTile(
          leading: Icon(Icons.logout_rounded, color: colorScheme.error),
          title: Text(
            '로그아웃',
            style: GudaTypography.body1(color: colorScheme.error),
          ),
          onTap: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('로그아웃', style: GudaTypography.heading3()),
                content: Text('로그아웃 하시겠습니까?', style: GudaTypography.body1()),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('취소'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text(
                      '로그아웃',
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
                ],
              ),
            );
            if (confirm == true && context.mounted) {
              await ref.read(authViewModelProvider.notifier).signOut();
            }
          },
        ),
      ],
    );
  }
}
