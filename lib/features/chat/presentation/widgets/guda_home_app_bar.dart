import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guda_chatbot/app/router/route_paths.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/home_viewmodel.dart';

class GudaHomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const GudaHomeAppBar({
    super.key,
    required this.isDark,
    required this.showBackButton,
    required this.activeId,
  });

  final bool isDark;
  final bool showBackButton;
  final String? activeId;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(
        AppStrings.appName,
        style: GudaTypography.heading2(
          color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
        ).copyWith(fontWeight: FontWeight.bold, letterSpacing: 2),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(showBackButton ? Icons.arrow_back : Icons.menu),
          onPressed: () {
            if (showBackButton) {
              ref.read(homeViewModelProvider.notifier).clearActiveConversation();
            } else {
              Scaffold.of(context).openDrawer();
            }
          },
        ),
      ),
      actions: [
        if (activeId == null)
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.push(RoutePaths.settings);
            },
          ),
      ],
    );
  }
}
