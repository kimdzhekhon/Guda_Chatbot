import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/design_system/design_system.dart';
import 'package:guda_chatbot/core/utils/guda_context_extensions.dart';

class GudaCopyright extends StatelessWidget {
  const GudaCopyright({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: 0.5,
        child: Text(
          '© ${DateTime.now().year} ${AppStrings.copyrightSuffix}',
          style: GudaTypography.caption(
            color: context.onSurfaceVariantColor,
          ),
        ),
      ),
    );
  }
}
