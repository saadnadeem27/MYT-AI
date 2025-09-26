// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:myt_ai/main.dart';

void main() {
  testWidgets('MYT AI App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MYTAIApp());

    // Verify that the app launches without crashing
    await tester.pump();

    // Check if key text elements are present
    expect(find.text('Welcome back,'), findsOneWidget);
  });
}
