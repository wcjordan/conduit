// Basic smoke test confirming the app boots with a rendered 4x4 puzzle.
// Feature-specific tests live under test/features/.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:conduit/main.dart';

void main() {
  testWidgets('App boots and shows the Conduit puzzle board', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: ConduitApp()));

    expect(find.text('Conduit'), findsOneWidget);
    expect(find.text('Moves: 0'), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);
  });
}
