import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:oracle_d_asgard/screens/games/snake/main_screen.dart';

class SnakePreliminaryScreen extends StatelessWidget {
  const SnakePreliminaryScreen({super.key});

  static Widget _buildBonusInfo(IconData icon, Color color, String name, String effect) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Text(
          '$name: ',
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          effect,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final Widget gameInfoLayout = Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.black.withAlpha(128), borderRadius: BorderRadius.circular(20)),
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
          const Text(
            'Bonus:',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildBonusInfo(Icons.flash_on, Colors.yellow, 'Speed', '+30% faster'),
          const SizedBox(height: 8),
          _buildBonusInfo(Icons.shield, Colors.blue, 'Shield', 'Destroy obstacles'),
          const SizedBox(height: 8),
          _buildBonusInfo(Icons.ac_unit, Colors.cyan, 'Freeze', '-30% slower'),
          const SizedBox(height: 8),
          _buildBonusInfo(Icons.visibility_off, Colors.grey, 'Ghost', 'Pass through obstacles'),
          const SizedBox(height: 8),
          const Text(
            'Effects last 8 seconds',
            style: TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );

    final Widget startButton = ChibiButton(
      text: 'snake_preliminary_screen_start_button'.tr(),
      color: const Color(0xFF22C55E), // Color from menu
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SnakeGame()));
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
                child: isLandscape
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(child: gameInfoLayout),
                          const SizedBox(width: 20),
                          startButton,
                        ],
                      )
                    : Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[gameInfoLayout, const SizedBox(height: 32), startButton]),
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
