import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/puzzle/screens/game_screen.dart';

void main() {
  runApp(const ProviderScope(child: ConduitApp()));
}

class ConduitApp extends StatelessWidget {
  const ConduitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conduit',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal)),
      home: const GameScreen(),
    );
  }
}
