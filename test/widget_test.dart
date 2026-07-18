import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agri_sense_ai/main.dart';

void main() {
  testWidgets('App should load and show splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AgriSenseApp());

    // Verify that splash screen content is shown.
    expect(find.text('Agri-Sense AI'), findsOneWidget);
    expect(find.byIcon(Icons.agriculture), findsOneWidget);

    // To handle the pending timer in SplashPage, we can pump and settle
    // but since it's a 3-second timer, we might just want to finish the test.
    // In a real scenario, we'd use fakeAsync or just ignore the timer if it's not needed for the test.
    await tester.pump(const Duration(seconds: 4));
  });
}
