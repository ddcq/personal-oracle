import 'package:flutter/material.dart';
import '../game_controller.dart';
import '../../myth_story_page.dart'; // Assurez-vous que le chemin est correct

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
        child: TextButton(
          onPressed: onValidate,
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
              color: const Color(0xFFEF4444).withAlpha(51),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFEF4444),
                width: 2,
              ),
            ),
            child: const Text(
              '❌ Désolé, l\'ordre est incorrect.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        
        if (controller.isOrderCompletelyCorrect())
          SizedBox(
            width: double.infinity,
            height: 60,
            child: TextButton(
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
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
          child: TextButton(
            onPressed: onReset,
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF06B6D4),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Rejouer avec un autre mythe',
              style: TextStyle(
                color: Colors.white,
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