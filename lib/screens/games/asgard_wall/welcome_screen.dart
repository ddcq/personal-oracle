import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';

class WelcomeScreenDialog extends StatelessWidget {
  const WelcomeScreenDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0F3460).withAlpha(217),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFFFD700), width: 1),
      ),
      title: const Text(
        'Règles du jeu:',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Construisez la muraille parfaite comme le géant bâtisseur.\nVotre objectif est de remplir toutes les cases jusqu’à la ligne dorée sans laisser de trous inaccessibles (fermés de tous les côtés).',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Contrôles:\n←→ ou A/D pour bouger\n↑/W/Space/Q/E pour pivoter\n↓/S pour descendre\n(Les contrôles tactiles sont disponibles en jeu)',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChibiButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: 'Fermer',
              color: const Color(0xFFFFD700),
            ),
          ],
        ),
      ],
    );
  }
}
