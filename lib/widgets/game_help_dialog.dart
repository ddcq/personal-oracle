import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle_d_asgard/widgets/app_dialog.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';

class GameHelpDialog {
  static void show(BuildContext context, List<String> rules, {VoidCallback? onGamePaused, VoidCallback? onGameResumed}) {
    onGamePaused?.call(); // Pause the game when dialog is shown

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
        icon: Icons.menu_book,
        titleStyle: theme.textTheme.headlineSmall?.copyWith(
          fontFamily: AppTextStyles.amaticSC,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24.sp,
          letterSpacing: 1.5.sp,
          shadows: [const Shadow(blurRadius: 10.0, color: Colors.black87, offset: Offset(3.0, 3.0))],
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: rules.map((rule) => _buildRule(rule, textStyle)).toList(),
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ChibiButton(
              text: "J'ai compris !",
              color: const Color(0xFFE53935),
              onPressed: () {
                onGameResumed?.call(); // Resume the game when dialog is dismissed
                Navigator.pop(ctx);
              },
            ),
          ),
        ],
      ),
    ).then((_) {
      // This callback is called when the dialog is dismissed by any means (e.g., tapping outside)
      // Ensure game is resumed even if not dismissed by the button
      onGameResumed?.call();
    });
  }

  static Widget _buildRule(String text, TextStyle? style) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: style?.copyWith(color: const Color(0xFF81D4FA))),
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