import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:oracle_d_asgard/screens/games/snake/main_screen.dart';

class SnakePreliminaryScreen extends StatelessWidget {
  const SnakePreliminaryScreen({super.key});

  static Widget _buildBonusInfo(
    String imagePath,
    String nameKey,
    String effectKey,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(imagePath, width: 24, height: 24),
        const SizedBox(width: 8),
        Text(
          '${nameKey.tr()}: ',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          effectKey.tr(),
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget gameInfoLayout = Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(128),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/preliminary/snake.webp', width: 120),
          const SizedBox(height: 16),
          Text(
            'snake_preliminary_screen_help_text'.tr(),
            style: const TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'snake_bonus_title'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildBonusInfo(
            'assets/images/snake/speed.png',
            'snake_bonus_speed_name',
            'snake_bonus_speed_effect',
          ),
          const SizedBox(height: 8),
          _buildBonusInfo(
            'assets/images/snake/shield.png',
            'snake_bonus_shield_name',
            'snake_bonus_shield_effect',
          ),
          const SizedBox(height: 8),
          _buildBonusInfo(
            'assets/images/snake/freeze.png',
            'snake_bonus_freeze_name',
            'snake_bonus_freeze_effect',
          ),
          const SizedBox(height: 8),
          _buildBonusInfo(
            'assets/images/snake/ghost.png',
            'snake_bonus_ghost_name',
            'snake_bonus_ghost_effect',
          ),
          const SizedBox(height: 8),
          Text(
            'snake_bonus_duration'.tr(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );

    final Widget startButton = ChibiButton(
      text: 'snake_preliminary_screen_start_button'.tr(),
      color: const Color(0xFF22C55E), // Color from menu
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SnakeGame()),
        );
      },
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: AppBackground(
        child: Stack(
          children: [
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    gameInfoLayout,
                    const SizedBox(height: 32),
                    startButton,
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.go('/games'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
