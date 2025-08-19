import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/app_dialog.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart'; // Added import
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Added import

import 'package:oracle_d_asgard/utils/text_styles.dart';

class HelpDialog {
  static void show(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyLarge?.copyWith(
      color: const Color(0xFFC5CAE9),
      fontSize: 16.sp, // Use .sp for responsive font size
      fontFamily: AppTextStyles.amarante,
    );

    showDialog(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Règles du jeu',
        icon: Icons.menu_book, // Changed icon to something more relevant for rules
        titleStyle: theme.textTheme.headlineSmall?.copyWith( // Added titleStyle parameter
          fontFamily: AppTextStyles.amaticSC,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24.sp, // Adjusted font size
          letterSpacing: 1.5.sp,
          shadows: [const Shadow(blurRadius: 10.0, color: Colors.black87, offset: Offset(3.0, 3.0))],
        ),
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
          SizedBox( // Wrap ChibiButton in SizedBox for consistent height
            width: double.infinity,
            height: 50.h,
            child: ChibiButton( // Replaced TextButton with ChibiButton
              text: 'J\'ai compris !',
              color: const Color(0xFFE53935), // Red color from main screen buttons
              onPressed: () => Navigator.pop(ctx),
              textStyle: TextStyle( // Define text style for ChibiButton
                fontSize: 16.sp,
                letterSpacing: 1.5.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildRule(String text, TextStyle? style) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: style?.copyWith(color: const Color(0xFF81D4FA))), // Use style for bullet point
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(text, style: style),
          ),
        ),
      ],
    );
  }
}

