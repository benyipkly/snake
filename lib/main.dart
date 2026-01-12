import 'package:flutter/material.dart';
import 'ui/game_screen.dart';

void main() {
  runApp(const SnakeApp());
}

class SnakeApp extends StatelessWidget {
  const SnakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retro Snake',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Optional: Pre-load fonts here if we added them
      ),
      home: const GameScreen(),
    );
  }
}
