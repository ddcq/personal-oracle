import 'package:flutter/material.dart';

// ==========================================
// QIX GAME - Conquête de Territoire
// ==========================================
class QixGame extends StatefulWidget {
  const QixGame({super.key});

  @override
  State<QixGame> createState() => _QixGameState();
}

class _QixGameState extends State<QixGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      appBar: AppBar(
        title: const Text(
          '🏴 Conquête de Territoire',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFFF6B35),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFF6B35).withOpacity(0.3)),
              ),
              child: const Column(
                children: [
                  Icon(Icons.crop_square, size: 80, color: Color(0xFFFF6B35)),
                  SizedBox(height: 16),
                  Text(
                    'Étends ton Royaume',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Trace des frontières pour conquérir\nle maximum de territoire ennemi',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // TODO: Lancer le jeu Qix
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Qix en cours de développement...')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Partir à la Conquête',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}