import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbuddy/main.dart';

void main() {
  testWidgets('GymBuddy App Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: GymBuddyApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Onboarding or Navigation Shell renders
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
