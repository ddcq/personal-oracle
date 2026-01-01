import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart'; // Import ChibiButton

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    final jeux = <_MiniJeuItem>[
      _MiniJeuItem(
        'games_menu_reorder_history'.tr(),
        'assets/images/menu/order_the_scrolls.webp',
        const Color(0xFF76A2A5),
        () => context.go('/order_the_scrolls_preliminary'),
      ),
      _MiniJeuItem(
        'games_menu_asgard_wall'.tr(),
        'assets/images/menu/asgard_wall.webp',
        const Color(0xFF2F3845),
        () => context.go('/asgard_wall_preliminary'),
      ),
      _MiniJeuItem(
        'games_menu_scattered_runes'.tr(),
        'assets/images/menu/puzzle.webp',
        const Color(0xFF5E6282),
        () => context.go('/puzzle_preliminary'),
      ),
      _MiniJeuItem(
        'games_menu_midgard_serpent'.tr(),
        'assets/images/menu/snake.webp',
        const Color(0xFFB9DAE3),
        () => context.go('/snake_preliminary'),
      ),
      _MiniJeuItem(
        'games_menu_territory_conquest'.tr(),
        'assets/images/menu/qix.webp',
        const Color(0xFF565575),
        () => context.go('/qix_preliminary'),
      ),
      _MiniJeuItem(
        'games_menu_odin_eye'.tr(),
        'assets/images/menu/word_search.webp',
        const Color(0xFF6E759F),
        () => context.go('/word_search_preliminary'),
      ),
      _MiniJeuItem(
        'games_menu_andvari_loot'.tr(),
        'assets/images/menu/minesweeper.webp',
        const Color(0xFF7B8295),
        () => context.go('/minesweeper_preliminary'),
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
        child: SafeArea(
          child: GridView.builder(
            padding: EdgeInsets.all(20.w),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.7,
            ),
            itemCount: jeux.length,
            itemBuilder: (context, index) {
              final jeu = jeux[index];
              return ChibiButton(
                    color: jeu.color,
                    onPressed: jeu.onPressed,
                    iconPath: jeu.iconPath,
                    text: jeu.label,
                    textStyle: TextStyle(
                      fontFamily: 'Amarante',
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: Colors.white,
                    ),
                  )
                  .animate(delay: (index * 120).ms)
                  .slideY(
                    begin: 0.2,
                    duration: 500.ms,
                    curve: Curves.easeOutCubic,
                  )
                  .fadeIn(duration: 300.ms);
            },
          ),
        ),
      ),
    );
  }
}

class _MiniJeuItem {
  final String label;
  final String iconPath;
  final Color color;
  final VoidCallback onPressed;

  _MiniJeuItem(this.label, this.iconPath, this.color, this.onPressed);
}
