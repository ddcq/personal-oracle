import 'package:flutter/material.dart';

// ==========================================
// PUZZLE GAME - Les Runes Dispersées
// ==========================================
class PuzzleGame extends StatefulWidget {
  const PuzzleGame({super.key});

  @override
  State<PuzzleGame> createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      appBar: AppBar(
        title: const Text(
          '🧩 Les Runes Dispersées',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF06B6D4),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF06B6D4).withAlpha(25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF06B6D4).withAlpha(76)),
              ),
              child: const Column(
                children: [
                  Icon(Icons.extension, size: 80, color: Color(0xFF06B6D4)),
                  SizedBox(height: 16),
                  Text(
                    'Reconstitue les Runes Sacrées',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Assemble les fragments des anciennes runes\npour déverrouiller leur pouvoir mystique',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // TODO: Lancer le jeu de puzzle
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Puzzle en cours de développement...')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06B6D4),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Commencer le Puzzle',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
