import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../widgets/widgets.dart';

/// The single MVP game screen: grid + move counter + basic app bar.
class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final solved = ref.watch(isPuzzleSolvedProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Conduit')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const MoveCounter(),
              const SizedBox(height: 8),
              Text(
                solved ? 'Solved!' : 'Rotate tiles to connect the network',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              const Expanded(child: Center(child: PuzzleBoard())),
            ],
          ),
        ),
      ),
    );
  }
}
