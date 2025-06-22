import 'package:flutter/material.dart';

class HelpDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.help_outline, color: Color(0xFF2E3B4E)),
            SizedBox(width: 8),
            Text('Règles du jeu'),
          ],
        ),
        content: const Text(
          'Remettez les cartes dans l\'ordre chronologique du mythe nordique.\n\n'
          '• Glissez une carte sur une autre pour les échanger\n'
          '• L\'icône ⭲ indique qu\'une carte est déplaçable\n'
          '• Organisez-les de la première à la dernière étape\n'
          '• Cliquez sur "Valider l\'ordre" pour vérifier\n'
          '• Les cartes correctes apparaîtront avec un contour vert ✅',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: const Text(
              'J\'ai compris !',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
