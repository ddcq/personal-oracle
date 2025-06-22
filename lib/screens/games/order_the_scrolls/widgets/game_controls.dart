import 'package:flutter/material.dart';
import '../game_controller.dart';

class GameControls extends StatelessWidget {
  final GameController controller;
  final VoidCallback onValidate;
  final VoidCallback onReset;

  const GameControls({
    super.key,
    required this.controller,
    required this.onValidate,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    if (!controller.validated) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: onValidate,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E3B4E),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: const Text(
            'Valider l\'ordre',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: controller.isOrderCompletelyCorrect()
                ? Colors.green[50]
                : Colors.red[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: controller.isOrderCompletelyCorrect()
                  ? Colors.green
                  : Colors.red,
              width: 2,
            ),
          ),
          child: Text(
            controller.isOrderCompletelyCorrect()
                ? '✅ Bravo ! Ordre correct !'
                : '❌ Désolé, l\'ordre est incorrect.',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: onReset,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: Color(0xFF2E3B4E),
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Rejouer avec un autre mythe',
              style: TextStyle(
                color: Color(0xFF2E3B4E),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
