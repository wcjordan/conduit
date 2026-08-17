// Board, tile, and move counter widgets.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';
import '../providers/providers.dart';

/// Renders the puzzle grid and handles tap-to-rotate.
class PuzzleBoard extends ConsumerWidget {
  const PuzzleBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzle = ref.watch(puzzleProvider);
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: puzzle.size,
        ),
        itemCount: puzzle.size * puzzle.size,
        itemBuilder: (context, index) {
          final row = index ~/ puzzle.size;
          final col = index % puzzle.size;
          return TileView(
            tile: puzzle.tileAt(row, col),
            onTap: () => ref.read(puzzleProvider.notifier).rotate(row, col),
          );
        },
      ),
    );
  }
}

/// A single tappable pipe tile, drawn as lines from the center to each of
/// its open edges — minimal/functional styling for the MVP.
class TileView extends StatelessWidget {
  const TileView({super.key, required this.tile, required this.onTap});

  final Tile tile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(4),
        ),
        child: CustomPaint(
          painter: _PipePainter(tile.openings, color: colorScheme.primary),
        ),
      ),
    );
  }
}

class _PipePainter extends CustomPainter {
  _PipePainter(this.openings, {required this.color});

  final Set<Direction> openings;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.shortestSide / 5
      ..strokeCap = StrokeCap.round;

    for (final direction in openings) {
      canvas.drawLine(center, _edgeMidpoint(direction, size), paint);
    }
    canvas.drawCircle(center, size.shortestSide / 8, paint);
  }

  Offset _edgeMidpoint(Direction direction, Size size) => switch (direction) {
    Direction.north => Offset(size.width / 2, 0),
    Direction.east => Offset(size.width, size.height / 2),
    Direction.south => Offset(size.width / 2, size.height),
    Direction.west => Offset(0, size.height / 2),
  };

  @override
  bool shouldRepaint(covariant _PipePainter oldDelegate) =>
      oldDelegate.openings != openings || oldDelegate.color != color;
}

/// Live move counter, incremented on every tile rotation.
class MoveCounter extends ConsumerWidget {
  const MoveCounter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moveCount = ref.watch(puzzleProvider.select((p) => p.moveCount));
    return Text(
      'Moves: $moveCount',
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}
