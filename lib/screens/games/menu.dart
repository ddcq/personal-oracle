import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:newton_particles/newton_particles.dart';

import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/widgets/epic_button.dart';
import 'package:oracle_d_asgard/widgets/hexagonal_grid.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';
import 'package:oracle_d_asgard/utils/translation_extensions.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  List<HexGridItem> _buildGridItems(BuildContext context) {
    final routes = [
      '/order_the_scrolls_preliminary',
      '/asgard_wall_preliminary',
      '/puzzle_preliminary',
      '/snake_preliminary',
      '/qix_preliminary',
      '/word_search_preliminary',
      '/minesweeper_preliminary',
      '/quiz_preliminary',
      '/norse_quiz_preliminary',
      '/visual_novel_preliminary',
    ];

    final images = [
      'assets/images/menu/order_the_scrolls.webp',
      'assets/images/menu/asgard_wall.webp',
      'assets/images/menu/puzzle.webp',
      'assets/images/menu/snake.webp',
      'assets/images/menu/qix.webp',
      'assets/images/menu/word_search.webp',
      'assets/images/menu/minesweeper.webp',
      'assets/images/menu/quiz.webp',
      'assets/images/menu/norse_quiz.webp',
      'assets/images/menu/visual_novel.webp',
    ];

    final gameNames = [
      'order_the_scrolls_title',
      'asgard_wall_title',
      'puzzle_title',
      'snake_title',
      'qix_title',
      'word_search_title',
      'minesweeper_title',
      'quiz_title',
      'norse_quiz_title',
      'visual_novel_title',
    ];

    return List.generate(
      routes.length,
      (i) => HexGridItem(
        onTap: () => context.go(routes[i]),
        child: TranslationBuilder(
          builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EpicButton(onPressed: () => context.go(routes[i]), imagePath: images[i], size: 60.sp),
              SizedBox(
                width: 130.w,
                child: Text(
                  gameNames[i].trAsync(),
                  style: ChibiTextStyles.appBarTitle.copyWith(
                    fontSize: 14.sp,
                    letterSpacing: 1.0.sp,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ChibiAppBar(
        titleText: 'games_menu_mini_games'.trAsync(),
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
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/images/wood.webp'), fit: BoxFit.cover),
                  ),
                  child: Newton(
                    effectConfigurations: [
                      // Effet lucioles dorées flottantes
                      DeterministicEffectConfiguration(
                        particleConfiguration: ParticleConfiguration(
                          shape: ImageAssetShape('assets/images/menu/star.webp'),
                          size: const Size(8, 8),
                          color: SingleParticleColor(color: Color(0xFFACFFFF)),
                        ),
                        emissionProperties: const EmissionProperties(
                          particleCount: 0,
                          emitDuration: Duration(milliseconds: 160),
                          particlesPerEmit: 1,
                          particleLifespan: DurationRange.between(Duration(seconds: 9), Duration(seconds: 18)),
                          origin: Offset(0.5, 0.5),
                          minOriginOffset: Offset(-0.45, -0.45),
                          maxOriginOffset: Offset(0.45, 0.45),
                        ),
                        layerProperties: const LayerProperties(particleLayer: ParticleLayer.foreground),
                        deterministicProperties: const DeterministicProperties(distance: NumRange.between(30, 120), angle: NumRange.between(-180, 180)),
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
                    child: Center(
                      child: SizedBox(
                        height: 580.h,
                        width: double.infinity,
                        child: Transform.translate(
                          offset: Offset(MediaQuery.of(context).size.width * 0.05, 50.h),
                          child: HexagonalGrid(
                            items: _buildGridItems(context),
                            columns: 3,
                            rows: 5,
                            hexSize: 55.0,
                            skipFirstTile: true,
                            horizontalOffset: 0.22,
                            verticalOffset: 0.15,
                            containerHeight: 580.h,
                          ),
                        ),
                      ),
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
