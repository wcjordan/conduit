// Basic smoke test confirming the app boots into the placeholder game screen.
// Feature-specific tests live under test/features/.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:conduit/main.dart';

void main() {
  testWidgets('App boots and shows the Conduit game screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: ConduitApp()));

    expect(find.text('Conduit'), findsOneWidget);
    expect(find.text('Puzzle board coming soon'), findsOneWidget);
  });
}
