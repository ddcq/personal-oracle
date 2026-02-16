import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/games/snake/main_screen.dart';
import 'package:oracle_d_asgard/widgets/preliminary_page.dart';
import 'package:oracle_d_asgard/providers/responsive_provider.dart';

class SnakePreliminaryScreen extends StatelessWidget {
  const SnakePreliminaryScreen({super.key});

  static Widget _buildBonusInfo(
    BuildContext context,
    String imagePath,
    String nameKey,
    String effectKey,
  ) {
    final responsive = Responsive(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(imagePath, width: 24, height: 24),
        const SizedBox(width: 8),
        Text(
          '${nameKey.tr()}: ',
          style: TextStyle(
            color: Colors.white,
            fontSize: responsive.sp(14),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          effectKey.tr(),
          style: TextStyle(color: Colors.white70, fontSize: responsive.sp(14)),
        ),
      ],
    );
  }

  Widget _buildCustomContent(BuildContext context) {
    final responsive = Responsive(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/menu/snake.webp', width: 120),
        const SizedBox(height: 16),
        Text(
          'snake_preliminary_screen_help_text'.tr(),
          style: TextStyle(color: Colors.white, fontSize: responsive.sp(18)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Text(
          'snake_bonus_title'.tr(),
          style: TextStyle(
            color: Colors.white,
            fontSize: responsive.sp(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildBonusInfo(
          context,
          'assets/images/snake/speed.png',
          'snake_bonus_speed_name',
          'snake_bonus_speed_effect',
        ),
        const SizedBox(height: 8),
        _buildBonusInfo(
          context,
          'assets/images/snake/shield.png',
          'snake_bonus_shield_name',
          'snake_bonus_shield_effect',
        ),
        const SizedBox(height: 8),
        _buildBonusInfo(
          context,
          'assets/images/snake/freeze.png',
          'snake_bonus_freeze_name',
          'snake_bonus_freeze_effect',
        ),
        const SizedBox(height: 8),
        _buildBonusInfo(
          context,
          'assets/images/snake/ghost.png',
          'snake_bonus_ghost_name',
          'snake_bonus_ghost_effect',
        ),
        const SizedBox(height: 8),
        Text(
          'snake_bonus_duration'.tr(),
          style: TextStyle(
            color: Colors.white70,
            fontSize: responsive.sp(12),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PreliminaryPage(
      title: 'games_menu_midgard_serpent',
      imagePath: 'assets/images/menu/snake.webp',
      helpText: 'snake_preliminary_screen_help_text',
      buttonText: 'snake_preliminary_screen_start_button',
      customContent: _buildCustomContent(context),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SnakeGame()),
        );
      },
    );
  }
}
