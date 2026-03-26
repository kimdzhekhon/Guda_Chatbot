import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

/// Guda 공통 앱바
class GudaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GudaAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
  });

  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return AppBar(
      title: Text(
        title,
        style: GudaTypography.heading3(
          color: isDark ? GudaColors.onSurfaceDark : GudaColors.onSurfaceLight,
        ),
      ),
      centerTitle: centerTitle,
      actions: actions,
      leading: leading,
      backgroundColor: isDark ? GudaColors.surfaceDark : GudaColors.surfaceLight,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: (isDark ? GudaColors.dividerDark : GudaColors.dividerLight)
              .withValues(alpha: 0.5),
          height: 0.5,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
