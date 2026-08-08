// Riverpod providers wiring puzzle logic to the UI.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logic/logic.dart';
import '../models/models.dart';

/// Holds the in-progress puzzle. The MVP starts a fresh hardcoded 4x4
/// puzzle every launch; procedural generation and persistence land later.
class PuzzleNotifier extends Notifier<PuzzleState> {
  @override
  PuzzleState build() => buildHardcodedFourByFourPuzzle();

  /// Rotates the tile at ([row], [col]) one quarter turn clockwise.
  void rotate(int row, int col) {
    state = state.rotateTile(row, col);
  }
}

final puzzleProvider = NotifierProvider<PuzzleNotifier, PuzzleState>(
  PuzzleNotifier.new,
);

/// Whether the current puzzle is solved. Kept separate from [puzzleProvider]
/// so widgets that only care about solved/unsolved don't rebuild on every
/// rotation unless the answer actually changes.
final isPuzzleSolvedProvider = Provider<bool>((ref) {
  return isPuzzleSolved(ref.watch(puzzleProvider));
});
