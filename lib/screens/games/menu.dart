import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    final jeux = <_MiniJeuItem>[
      _MiniJeuItem(
        'games_menu_reorder_history'.tr(),
        const Color(0xFF6366F1),
        () => context.go('/order_the_scrolls_preliminary'),
      ),
      _MiniJeuItem(
        'games_menu_asgard_wall'.tr(),
        const Color(0xFFEF4444),
        () => context.go('/asgard_wall_preliminary'),
      ),
      _MiniJeuItem(
        'games_menu_scattered_runes'.tr(),
        const Color(0xFF06B6D4),
        () => context.go('/puzzle_preliminary'),
      ),
      _MiniJeuItem(
        'games_menu_midgard_serpent'.tr(),
        const Color(0xFF22C55E),
        () => context.go('/snake_preliminary'),
      ),
      _MiniJeuItem(
        'games_menu_territory_conquest'.tr(),
        const Color(0xFFFF6B35),
        () => context.go('/qix_preliminary'),
      ),
      _MiniJeuItem(
        'games_menu_odin_eye'.tr(),
        const Color(0xFF8B5CF6),
        () => context.go('/word_search_preliminary'),
      ),
      _MiniJeuItem(
        'games_menu_andvari_loot'.tr(),
        Colors.brown,
        () => context.go('/minesweeper_preliminary'),
      ),
    ];
    return Scaffold(
      extendBodyBehindAppBar:
          true, // Permet au body de s’étendre derrière l’AppBar
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
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Generate ChibiButtons from the jeux list
                  ...jeux.asMap().entries.map((entry) {
                    int index = entry.key;
                    _MiniJeuItem jeu = entry.value;
                    return Padding(
                          padding: EdgeInsets.only(bottom: 15.h),
                          child: ChibiButton(
                            text: jeu.label,
                            color: jeu.color,
                            onPressed: jeu.onPressed,
                          ),
                        )
                        .animate(delay: (index * 120).ms)
                        .slideY(
                          begin: 0.2,
                          duration: 500.ms,
                          curve: Curves.easeOutCubic,
                        )
                        .fadeIn(duration: 300.ms);
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniJeuItem {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  _MiniJeuItem(this.label, this.color, this.onPressed);
}
