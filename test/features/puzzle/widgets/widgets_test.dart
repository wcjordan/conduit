// Trivial widget test confirming the widget test harness is wired up
// correctly. Replace with real board/tile/move-counter widget tests.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:conduit/features/puzzle/widgets/widgets.dart';

void main() {
  testWidgets('widgets scaffold placeholder renders', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: WidgetsScaffoldPlaceholder()),
    );

    expect(find.text('widgets scaffold ready'), findsOneWidget);
  });
}
