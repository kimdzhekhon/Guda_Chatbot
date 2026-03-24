import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guda_chatbot/features/chat/presentation/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify AppBar title
    expect(find.text('Guda'), findsOneWidget);

    // Verify presence of Classic Cards
    expect(find.text('팔만대장경'), findsOneWidget);
    expect(find.text('주역(周易)'), findsOneWidget);

    // Verify 'Start New Chat' button exists
    expect(find.text('새 대화 시작'), findsOneWidget);

    // Verify Drawer hamburger icon exists
    expect(find.byIcon(Icons.menu), findsOneWidget);

    // Initial state should not show Chat input bar (TextField)
    expect(find.byType(TextField), findsNothing);
  });
}
