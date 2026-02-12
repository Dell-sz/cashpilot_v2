// This is a basic Flutter widget test.
//
// To perform an interaction with your widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cashpilot_v2/main.dart';

void main() {
  testWidgets('CashPilot loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CashPilotApp());

    // Verify that the app title appears.
    expect(find.text('CashPilot V2 🚀'), findsOneWidget);
  });
}
