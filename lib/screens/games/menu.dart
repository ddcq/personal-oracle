import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/epic_button.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    final jeux = <_MiniJeuItem>[
      _MiniJeuItem(
        'games_menu_reorder_history'.tr(),
        'assets/images/menu/order_the_scrolls.webp',
        () => context.go('/order_the_scrolls_preliminary'),
      ),
      _MiniJeuItem(
        'games_menu_asgard_wall'.tr(),
        'assets/images/menu/asgard_wall.webp',
        () => context.go('/asgard_wall_preliminary'),
      ),
      _MiniJeuItem(
        'games_menu_scattered_runes'.tr(),
        'assets/images/menu/puzzle.webp',
        () => context.go('/puzzle_preliminary'),
      ),
      _MiniJeuItem(
        'games_menu_midgard_serpent'.tr(),
        'assets/images/menu/snake.webp',
        () => context.go('/snake_preliminary'),
      ),
      _MiniJeuItem(
        'games_menu_territory_conquest'.tr(),
        'assets/images/menu/qix.webp',
        () => context.go('/qix_preliminary'),
      ),
      _MiniJeuItem(
        'games_menu_odin_eye'.tr(),
        'assets/images/menu/word_search.webp',
        () => context.go('/word_search_preliminary'),
      ),
      _MiniJeuItem(
        'games_menu_andvari_loot'.tr(),
        'assets/images/menu/minesweeper.webp',
        () => context.go('/minesweeper_preliminary'),
      ),
      _MiniJeuItem(
        'games_menu_quiz'.tr(),
        'assets/images/menu/quiz.webp',
        () => context.go('/quiz_preliminary'),
      ),
    ];
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ChibiAppBar(
        titleText: 'games_menu_mini_games'.tr(),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: AppBackground(
        imagePath: 'assets/images/backgrounds/main.jpg',
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/wood.webp'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Central button
                      EpicButton(
                        onPressed: jeux[7].onPressed,
                        imagePath: jeux[7].iconPath,
                        size: 100.sp,
                      ),
                      // Surrounding buttons
                      for (var i = 0; i < 7; i++)
                        Transform.translate(
                          offset: Offset.fromDirection(i * (2 * pi / 7), 120.r),
                          child: EpicButton(
                            onPressed: jeux[i].onPressed,
                            imagePath: jeux[i].iconPath,
                            size: 100.sp,
                          ),
                        ),
                    ],
                  ), // This closes the Stack
                ), // This closes the Container
              ), // This closes the Expanded
            ], // This closes the children list of Column
          ), // This closes the Column
        ),
      ),
    );
  }
}

class _MiniJeuItem {
  final String label;
  final String iconPath;
  final VoidCallback onPressed;

  _MiniJeuItem(this.label, this.iconPath, this.onPressed);
}
