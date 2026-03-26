import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/home_app_bar_actions.dart';
import 'package:guda_chatbot/features/chat/presentation/widgets/home_app_bar_leading.dart';

class GudaHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GudaHomeAppBar({
    super.key,
    required this.showBackButton,
    required this.activeId,
    this.hideChatCount = false,
  });

  final bool showBackButton;
  final String? activeId;
  final bool hideChatCount;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        AppStrings.appName,
        style: GudaTypography.heading2(
          color: context.onSurfaceColor,
        ).copyWith(fontWeight: FontWeight.bold, letterSpacing: 2),
      ),
      leading: HomeAppBarLeading(showBackButton: showBackButton),
      actions: [
        HomeAppBarActions(
          activeId: activeId,
          hideChatCount: hideChatCount,
        ),
      ],
    );
  }
}
