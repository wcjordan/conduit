// Puzzle logic: the hardcoded MVP puzzle and win-detection (connectivity).

import '../models/models.dart';

/// Builds the single hardcoded 4x4 puzzle used for the MVP, ahead of
/// procedural generation. The solved layout below is a fixed spanning tree
/// over the 4x4 grid (so it's guaranteed solvable as one connected network
/// with no dead ends), scrambled by rotating every tile one quarter turn
/// away from its solved orientation so play doesn't start pre-solved.
PuzzleState buildHardcodedFourByFourPuzzle() {
  // (type, solved rotation) for every cell, row-major. Solved rotation is
  // the orientation whose openings line up with this fixed tree's edges.
  const layout = [
    [
      (TileType.endpoint, 1),
      (TileType.tJunction, 1),
      (TileType.straight, 1),
      (TileType.elbow, 2),
    ],
    [
      (TileType.endpoint, 1),
      (TileType.cross, 0),
      (TileType.elbow, 2),
      (TileType.endpoint, 0),
    ],
    [
      (TileType.elbow, 1),
      (TileType.tJunction, 2),
      (TileType.elbow, 0),
      (TileType.endpoint, 3),
    ],
    [
      (TileType.endpoint, 0),
      (TileType.elbow, 0),
      (TileType.straight, 1),
      (TileType.endpoint, 3),
    ],
  ];

  final tiles = [
    for (final row in layout)
      [
        for (final (type, solvedRotation) in row)
          Tile(
            type: type,
            // Cross tiles look identical at every rotation, so there's no
            // point scrambling them.
            rotation: type == TileType.cross
                ? solvedRotation
                : (solvedRotation + 1) % 4,
          ),
      ],
  ];

  return PuzzleState(size: 4, tiles: tiles);
}

/// A puzzle is solved when every tile's openings connect to a matching
/// opening on its neighbor — no opening points off the grid or at a
/// neighbor that isn't reciprocating — *and* every tile is reachable from
/// every other tile through those connections: a single connected network
/// with no dead ends or overlaps, per the MVP win condition.
bool isPuzzleSolved(PuzzleState state) {
  final size = state.size;

  // 1. No dead ends or overlaps: every opening must be reciprocated by the
  // neighbor it points at, and no opening may point off the grid.
  for (var row = 0; row < size; row++) {
    for (var col = 0; col < size; col++) {
      for (final direction in state.tileAt(row, col).openings) {
        final (dr, dc) = direction.delta;
        final neighborRow = row + dr;
        final neighborCol = col + dc;
        if (!state.inBounds(neighborRow, neighborCol)) {
          return false;
        }
        final neighborOpenings = state
            .tileAt(neighborRow, neighborCol)
            .openings;
        if (!neighborOpenings.contains(direction.opposite)) {
          return false;
        }
      }
    }
  }

  // 2. Single connected network: every tile must be reachable from any
  // other tile via matched openings (already confirmed reciprocal above).
  final visited = <int>{0};
  final stack = [0];
  while (stack.isNotEmpty) {
    final current = stack.removeLast();
    final row = current ~/ size;
    final col = current % size;
    for (final direction in state.tileAt(row, col).openings) {
      final (dr, dc) = direction.delta;
      final neighborIndex = (row + dr) * size + (col + dc);
      if (visited.add(neighborIndex)) {
        stack.add(neighborIndex);
      }
    }
  }

  return visited.length == size * size;
}
