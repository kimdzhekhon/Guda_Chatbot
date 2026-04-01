import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:guda_chatbot/app/router/route_paths.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_button.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_divider.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_action_icon_button.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/home_viewmodel.dart';

class DrawerUserFooter extends ConsumerWidget {
  const DrawerUserFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(GudaSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const GudaDivider(height: 1),
          const SizedBox(height: GudaSpacing.md),
          Row(
            children: [
              GudaActionIconButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.push(RoutePaths.bookmarks);
                },
                icon: Icons.bookmarks_outlined,
              ),
              const SizedBox(width: GudaSpacing.xs),
              GudaActionIconButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.push(RoutePaths.settings);
                },
                icon: Icons.settings_outlined,
              ),
              const SizedBox(width: GudaSpacing.md),
              Expanded(
                child: GudaButton.outlined(
                  onPressed: () {
                    ref
                        .read(homeViewModelProvider.notifier)
                        .clearActiveChatRoom();
                    Navigator.pop(context);
                  },
                  icon: Icons.add_rounded,
                  label: AppStrings.newChat,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
