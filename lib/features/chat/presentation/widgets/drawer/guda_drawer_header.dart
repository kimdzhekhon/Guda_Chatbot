import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_brand_header.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

class GudaDrawerHeader extends StatelessWidget {
  const GudaDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: GudaSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.surfaceColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GudaBrandHeader(
            isLarge: false,
            showLogo: false,
            title: AppStrings.historyHeader,
            color: context.onSurfaceColor,
          ),
          const SizedBox(height: GudaSpacing.md),
        ],
      ),
    );
  }
}
