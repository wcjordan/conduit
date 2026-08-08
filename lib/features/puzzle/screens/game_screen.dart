import 'package:flutter/material.dart';

/// Placeholder for the single MVP game screen (grid + move counter + app bar).
/// Real board rendering and puzzle logic are added in later work.
class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conduit')),
      body: const Center(child: Text('Puzzle board coming soon')),
    );
  }
}
