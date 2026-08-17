// Puzzle domain models: directions, tile shapes/rotation, and grid state.

/// The four compass directions a pipe opening can point in, in clockwise
/// order starting at north so `(index + steps) % 4` is a quarter turn.
enum Direction {
  north,
  east,
  south,
  west;

  /// The direction directly opposite this one, used to check that two
  /// adjacent tiles' openings line up with each other.
  Direction get opposite => Direction.values[(index + 2) % 4];

  /// This direction rotated clockwise by [steps] quarter turns.
  Direction rotatedBy(int steps) => Direction.values[(index + steps) % 4];

  /// The (row, col) delta to step one cell in this direction.
  (int, int) get delta => switch (this) {
    Direction.north => (-1, 0),
    Direction.east => (0, 1),
    Direction.south => (1, 0),
    Direction.west => (0, -1),
  };
}

/// The shape of pipe carved into a tile, independent of its current
/// rotation. Each type lists the openings it has at rotation 0; rotating a
/// tile shifts every opening the same number of steps clockwise.
enum TileType {
  /// A single opening — a dead end. Sits at the leaves of the puzzle's
  /// spanning tree, where only one neighbor needs to connect.
  endpoint(<Direction>{Direction.north}),

  /// Two opposite openings — passes straight through.
  straight(<Direction>{Direction.north, Direction.south}),

  /// Two adjacent openings — turns a corner.
  elbow(<Direction>{Direction.north, Direction.east}),

  /// Three openings — branches two ways.
  tJunction(<Direction>{Direction.north, Direction.east, Direction.south}),

  /// All four openings — branches every way, identical at every rotation.
  cross(<Direction>{
    Direction.north,
    Direction.east,
    Direction.south,
    Direction.west,
  });

  const TileType(this.baseOpenings);

  /// Openings this tile type has at rotation 0.
  final Set<Direction> baseOpenings;
}

/// A single grid cell: a pipe shape plus how many quarter turns clockwise
/// it has been rotated away from its base orientation.
class Tile {
  const Tile({required this.type, this.rotation = 0});

  final TileType type;

  /// Number of 90° clockwise turns applied, in the range 0-3.
  final int rotation;

  /// The directions this tile currently has an opening in.
  Set<Direction> get openings =>
      type.baseOpenings.map((d) => d.rotatedBy(rotation)).toSet();

  /// A copy of this tile rotated one quarter turn clockwise.
  Tile rotated() => Tile(type: type, rotation: (rotation + 1) % 4);
}

/// The full state of a puzzle in progress: the grid of tiles plus the
/// running move counter.
class PuzzleState {
  PuzzleState({
    required this.size,
    required List<List<Tile>> tiles,
    this.moveCount = 0,
  }) : tiles = List.unmodifiable(tiles.map(List<Tile>.unmodifiable));

  /// Grid side length (the puzzle is always square).
  final int size;

  /// Tiles indexed as `tiles[row][col]`.
  final List<List<Tile>> tiles;

  /// Number of rotations made so far this puzzle.
  final int moveCount;

  Tile tileAt(int row, int col) => tiles[row][col];

  bool inBounds(int row, int col) =>
      row >= 0 && row < size && col >= 0 && col < size;

  /// A copy of this state with the tile at ([row], [col]) rotated one
  /// quarter turn clockwise and the move counter incremented.
  PuzzleState rotateTile(int row, int col) {
    final updated = [
      for (var r = 0; r < size; r++)
        [
          for (var c = 0; c < size; c++)
            r == row && c == col ? tiles[r][c].rotated() : tiles[r][c],
        ],
    ];
    return PuzzleState(size: size, tiles: updated, moveCount: moveCount + 1);
  }
}
