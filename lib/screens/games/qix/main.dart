import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'qix_game.dart';
import 'directional_pad.dart';
import 'constants.dart';

class QixGameScreen extends StatelessWidget {
  const QixGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final QixGame game = QixGame();
    return Scaffold(
      appBar: AppBar(title: const Text('Qix Basic')),
      body: Stack(
        children: [
          GameWidget(game: game),
          DirectionalPad(
            onDirectionChanged: (Direction direction) {
              game.handleDirectionChange(direction);
            },
          ),
        ],
      ),
    );
  }
}