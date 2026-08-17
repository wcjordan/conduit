// Widget tests for the puzzle board: rendering and tap-to-rotate.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:conduit/features/puzzle/providers/providers.dart';
import 'package:conduit/features/puzzle/widgets/widgets.dart';

void main() {
  testWidgets('renders one tile per cell of the 4x4 puzzle', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: PuzzleBoard())),
      ),
    );

    expect(find.byType(TileView), findsNWidgets(16));
  });

  testWidgets('tapping a tile rotates it and bumps the move counter', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: PuzzleBoard())),
      ),
    );

    expect(container.read(puzzleProvider).moveCount, 0);

    await tester.tap(find.byType(TileView).first);
    await tester.pump();

    expect(container.read(puzzleProvider).moveCount, 1);
  });
}
