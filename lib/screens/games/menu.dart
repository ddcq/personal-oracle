import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:newton_particles/newton_particles.dart';

import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
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
                  child: Newton(
                    effectConfigurations: [
                      // Effet lucioles dorées flottantes
                      DeterministicEffectConfiguration(
                        particleConfiguration: ParticleConfiguration(
                          shape: ImageAssetShape(
                            'assets/images/menu/star.webp',
                          ),
                          size: const Size(8, 8),
                          color: SingleParticleColor(color: Color(0xFFACFFFF)),
                        ),
                        emissionProperties: const EmissionProperties(
                          particleCount: 0,
                          emitDuration: Duration(milliseconds: 160),
                          particlesPerEmit: 1,
                          particleLifespan: DurationRange.between(
                            Duration(seconds: 9),
                            Duration(seconds: 18),
                          ),
                          origin: Offset(0.5, 0.5),
                          minOriginOffset: Offset(-0.45, -0.45),
                          maxOriginOffset: Offset(0.45, 0.45),
                        ),
                        layerProperties: const LayerProperties(
                          particleLayer: ParticleLayer.foreground,
                        ),
                        deterministicProperties: const DeterministicProperties(
                          distance: NumRange.between(30, 120),
                          angle: NumRange.between(-180, 180),
                        ),
                        visualProperties: const VisualProperties(
                          beginScale: NumRange.between(0.6, 1.0),
                          endScale: NumRange.between(1.5, 2.5),
                          fadeInThreshold: NumRange.between(0, 0.2),
                          fadeOutThreshold: NumRange.between(0.7, 0.9),
                          fadeInCurve: Curves.easeInOut,
                          fadeOutCurve: Curves.easeInOut,
                          scaleCurve: Curves.easeInOutSine,
                        ),
                        distanceCurve: Curves.easeInOutQuad,
                      ),
                    ],
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
                            offset: Offset.fromDirection(
                              i * (2 * pi / 7),
                              120.r,
                            ),
                            child: EpicButton(
                              onPressed: jeux[i].onPressed,
                              imagePath: jeux[i].iconPath,
                              size: 100.sp,
                            ),
                          ),
                      ],
                    ),
                  ), // This closes the Newton + Stack
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
