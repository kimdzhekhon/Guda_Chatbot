import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guda_chatbot/features/chat/presentation/viewmodels/home_viewmodel.dart';

class HomeAppBarLeading extends ConsumerWidget {
  const HomeAppBarLeading({
    super.key,
    required this.showBackButton,
  });

  final bool showBackButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(showBackButton ? Icons.arrow_back : Icons.menu),
      onPressed: () {
        if (showBackButton) {
          ref.read(homeViewModelProvider.notifier).clearActiveConversation();
        } else {
          Scaffold.of(context).openDrawer();
        }
      },
    );
  }
}
