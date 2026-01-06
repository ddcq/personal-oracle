import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle_d_asgard/widgets/app_dialog.dart';
import 'package:oracle_d_asgard/widgets/epic_icon_button.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';

class GameHelpDialog extends StatelessWidget {
  final List<String> helpTexts;
  final VoidCallback onGameResumed;
  final VoidCallback? onGoToHome;

  const GameHelpDialog({
    super.key,
    required this.helpTexts,
    required this.onGameResumed,
    this.onGoToHome,
  });

  static void show(
    BuildContext context,
    List<String> helpTexts, {
    required VoidCallback onGamePaused,
    required VoidCallback onGameResumed,
    VoidCallback? onGoToHome,
  }) {
    onGamePaused();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GameHelpDialog(
          helpTexts: helpTexts,
          onGameResumed: () {
            Navigator.of(context).pop();
            onGameResumed();
          },
          onGoToHome: onGoToHome,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyLarge?.copyWith(
      color: const Color(0xFFC5CAE9),
      fontSize: 16.sp, // Use .sp for responsive font size
      fontFamily: AppTextStyles.amarante,
    );

    return AppDialog(
      title: 'widgets_game_help_dialog_title'.tr(),
      icon: Icons.menu_book,
      titleStyle: theme.textTheme.headlineSmall?.copyWith(
        fontFamily: AppTextStyles.amaticSC,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 24.sp,
        letterSpacing: 1.5.sp,
        shadows: [
          const Shadow(
            blurRadius: 10.0,
            color: Colors.black87,
            offset: Offset(3.0, 3.0),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: helpTexts
              .map((text) => _buildRule(text, textStyle))
              .toList(),
        ),
      ),
      actions: [
        if (onGoToHome != null)
          EpicIconButton(
            color: ChibiColors.buttonRed,
            onPressed: onGoToHome,
            icon: const Icon(Icons.home, color: Colors.white, size: 32),
          ),
        EpicIconButton(
          color: ChibiColors.buttonBlue,
          onPressed: onGameResumed,
          icon: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
        ),
      ],
    );
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
