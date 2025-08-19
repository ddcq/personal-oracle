import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';

class GameOverPopup extends StatelessWidget {
  final int score;
  final VoidCallback onResetGame;

  const GameOverPopup({super.key, required this.score, required this.onResetGame});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F23),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF22C55E)),
        ),
        child: Column(
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
            const SizedBox(height: 16),
            ChibiButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onResetGame(); // Trigger game reset
              },
              text: 'Renaître',
              color: const Color(0xFF22C55E),
            ),
          ],
        ),
      ),
    );
  }
}
