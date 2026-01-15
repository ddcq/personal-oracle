import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/chibi_text_button.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';
import 'package:oracle_d_asgard/screens/games/word_search/main_screen.dart';

class WordSearchPreliminaryScreen extends StatelessWidget {
  const WordSearchPreliminaryScreen({super.key});

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
          Image.asset(
            'assets/images/menu/word_search.webp',
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 16),
          Text(
            'word_search_preliminary_screen_help_text'.tr(),
            style: const TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    final Widget startButton = ChibiTextButton(
      text: 'word_search_preliminary_screen_start_button'.tr(),
      color: ChibiColors.darkEpicPurple,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WordSearchScreen()),
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
                    Text(
                      'games_menu_odin_eye'.tr(),
                      style: ChibiTextStyles.appBarTitle.copyWith(fontSize: 32),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
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
