import 'package:flutter/material.dart';
import 'package:guda_chatbot/core/constants/app_strings.dart';
import 'package:guda_chatbot/core/ui/widgets/guda_brand_header.dart';

class AuthBranding extends StatelessWidget {
  const AuthBranding({super.key});

  @override
  Widget build(BuildContext context) {
    return const GudaBrandHeader(
      subtitle: AppStrings.authSubtitle,
    );
  }
}
