// Unit tests for the hardcoded MVP puzzle and win-detection logic.

import 'package:flutter_test/flutter_test.dart';

import 'package:conduit/features/puzzle/logic/logic.dart';
import 'package:conduit/features/puzzle/models/models.dart';

/// Rotates every tile in [puzzle] back to its solved orientation. The
/// hardcoded layout scrambles every non-cross tile by exactly one quarter
/// turn, so three more taps per tile undoes it (crosses need none).
PuzzleState _solve(PuzzleState puzzle) {
  var solved = puzzle;
  for (var row = 0; row < solved.size; row++) {
    for (var col = 0; col < solved.size; col++) {
      final turnsNeeded = solved.tileAt(row, col).type == TileType.cross
          ? 0
          : 3;
      for (var i = 0; i < turnsNeeded; i++) {
        solved = solved.rotateTile(row, col);
      }
    }
  }
  return solved;
}

void main() {
  group('buildHardcodedFourByFourPuzzle', () {
    test('produces a 4x4 grid that starts unsolved with zero moves', () {
      final puzzle = buildHardcodedFourByFourPuzzle();

      expect(puzzle.size, 4);
      expect(puzzle.moveCount, 0);
      expect(isPuzzleSolved(puzzle), isFalse);
    });
  });

  group('isPuzzleSolved', () {
    test('is true once every tile is rotated back to its solved orientation', () {
      final puzzle = _solve(buildHardcodedFourByFourPuzzle());

      expect(isPuzzleSolved(puzzle), isTrue);
      // 15 non-cross tiles x 3 taps each to undo the one-turn scramble.
      expect(puzzle.moveCount, 45);
    });

    test('a single mis-rotated tile breaks the solved network', () {
      final solved = _solve(buildHardcodedFourByFourPuzzle());
      expect(isPuzzleSolved(solved), isTrue);

      final mismatched = solved.rotateTile(0, 2);
      expect(isPuzzleSolved(mismatched), isFalse);
    });
  });

  group('Tile', () {
    test('rotating a straight tile cycles between vertical and horizontal', () {
      const tile = Tile(type: TileType.straight);
      expect(tile.openings, {Direction.north, Direction.south});

      final rotatedOnce = tile.rotated();
      expect(rotatedOnce.openings, {Direction.east, Direction.west});

      final rotatedTwice = rotatedOnce.rotated();
      expect(rotatedTwice.openings, {Direction.north, Direction.south});
    });

    test('rotating a cross tile always exposes all four openings', () {
      const tile = Tile(type: TileType.cross);
      expect(tile.rotated().openings, tile.openings);
    });

    test('an elbow tile turns a corner and cycles through 4 orientations', () {
      const tile = Tile(type: TileType.elbow);
      expect(tile.openings, {Direction.north, Direction.east});
      expect(tile.rotated().openings, {Direction.east, Direction.south});
      expect(tile.rotated().rotated().openings, {
        Direction.south,
        Direction.west,
      });
      expect(tile.rotated().rotated().rotated().openings, {
        Direction.west,
        Direction.north,
      });
    });
  });
}
