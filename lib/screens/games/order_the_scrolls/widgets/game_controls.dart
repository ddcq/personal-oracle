import 'package:flutter/material.dart';
import '../game_controller.dart';
import '../myth_story_page.dart'; // Assurez-vous que le chemin est correct

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
        if (!controller.isOrderCompletelyCorrect())
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.red,
                width: 2,
              ),
            ),
            child: const Text(
              '❌ Désolé, l\'ordre est incorrect.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        
        if (controller.isOrderCompletelyCorrect())
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MythStoryPage(
                      mythStory: controller.selectedStory,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book_outlined, size: 24),
                  SizedBox(width: 8),
                  Text(
                    '✅ Bravo ! Lire l\'histoire complète',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
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