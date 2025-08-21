import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:oracle_d_asgard/widgets/game_over_popup.dart';

class SnakeGameOverPopup extends StatelessWidget {
  final int score;
  final VoidCallback onResetGame;

  const SnakeGameOverPopup({
    super.key,
    required this.score,
    required this.onResetGame,
  });

  @override
  Widget build(BuildContext context) {
    return GameOverPopup(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '⚰️ Ragnarök !',
            style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Jörmungandr a péri...\nScore final: $score',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        ChibiButton(
          onPressed: () {
            Navigator.of(context).pop();
            onResetGame();
          },
          text: 'Renaître',
          color: const Color(0xFF22C55E),
        ),
      ],
    );
  }
}
