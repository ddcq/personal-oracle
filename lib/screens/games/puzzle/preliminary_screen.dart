import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/widgets/chibi_text_button.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';

import 'package:oracle_d_asgard/screens/games/puzzle/main_screen.dart';

import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/providers/responsive_provider.dart';

// =========================================
// PUZZLE GAME - Les Runes Dispersées
// =========================================
class PuzzlePreliminaryScreen extends StatefulWidget {
  const PuzzlePreliminaryScreen({super.key});

  @override
  State<PuzzlePreliminaryScreen> createState() =>
      _PuzzlePreliminaryScreenState();
}

class _PuzzlePreliminaryScreenState extends State<PuzzlePreliminaryScreen> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final Widget puzzleLayout = Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(128),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Image.asset('assets/images/menu/puzzle.webp', width: 120),
          const SizedBox(height: 16),
          Text(
            'puzzle_preliminary_screen_help_text'.tr(),
            style: TextStyle(color: Colors.white, fontSize: responsive.sp(18)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
    final Widget startButton = ChibiTextButton(
      text: 'puzzle_preliminary_screen_start_button'.tr(),
      color: ChibiColors.darkEpicPurple,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PuzzleScreen()),
        );
      },
    );
    return Scaffold(
      backgroundColor: Colors.transparent, // Make the scaffold transparent
      extendBodyBehindAppBar: true,
      body: AppBackground(
        child: Stack(
          children: [
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Builder(
                      builder: (context) {
                        final responsive = Responsive(context);
                        return Text(
                          'puzzle_screen_title'.tr(),
                          style: ChibiTextStyles.appBarTitleResponsive(context).copyWith(
                            fontSize: responsive.sp(32),
                          ),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    puzzleLayout,
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
