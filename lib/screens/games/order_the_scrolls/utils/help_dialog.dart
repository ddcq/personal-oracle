import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/app_dialog.dart';

class HelpDialog {
  static void show(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyLarge?.copyWith(
      color: const Color(0xFFC5CAE9),
      fontSize: 16,
    );

    showDialog(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Règles du jeu',
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(
                'Remettez les cartes dans l\'ordre chronologique du mythe nordique.',
                style: textStyle,
              ),
              const SizedBox(height: 16),
              _buildRule(
                'Glissez une carte sur une autre pour les échanger.',
                textStyle,
              ),
              _buildRule(
                'L\'icône ⭲ indique qu\'une carte est déplaçable.',
                textStyle,
              ),
              _buildRule(
                'Organisez-les de la première à la dernière étape.',
                textStyle,
              ),
              _buildRule(
                'Cliquez sur "Valider l\'ordre" pour vérifier.',
                textStyle,
              ),
              _buildRule(
                'Les cartes correctes apparaîtront avec un contour vert ✅.',
                textStyle,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF81D4FA).withAlpha(51),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'J\'ai compris !',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildRule(String text, TextStyle? style) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Color(0xFF81D4FA), fontSize: 16)),
          Expanded(child: Text(text, style: style)),
        ],
      ),
    );
  }
}

