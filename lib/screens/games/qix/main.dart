import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'qix_game.dart';

class QixGameScreen extends StatelessWidget {
  const QixGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qix Basic')),
      body: GameWidget(game: QixGame()),
    );
  }
}