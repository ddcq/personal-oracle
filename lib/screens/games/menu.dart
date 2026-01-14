import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:newton_particles/newton_particles.dart';
import 'package:hexagon/hexagon.dart';

import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/widgets/epic_button.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  Widget? _buildHexagonButton(int col, int row, BuildContext context) {
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
      'games_menu_reorder_history',
      'games_menu_asgard_wall',
      'puzzle_screen_title',
      'games_menu_midgard_serpent',
      'games_menu_territory_conquest',
      'games_menu_scattered_runes',
      'games_menu_odin_eye',
      'games_menu_quiz',
      'games_menu_norse_quiz',
      'visual_novel_title',
    ];

    final index = row * 3 + col;
    // Skip first tile (index 0) to have 2 buttons on first row and 3 on second row
    if (index == 0 || index > routes.length) return null;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EpicButton(
            onPressed: () => context.go(routes[index - 1]),
            imagePath: images[index - 1],
            size: 100.sp,
          ),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFd4af37).withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Text(
              gameNames[index - 1].tr(),
              style: TextStyle(
                color: const Color(0xFFd4af37),
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(1.w, 1.h),
                    blurRadius: 2,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Center(
                      child: SizedBox(
                        height: 500.h,
                        width: double.infinity,
                        child: Transform.translate(
                          offset: Offset(
                            MediaQuery.of(context).size.width * 0.05,
                            50.h,
                          ),
                          child: Transform.rotate(
                            angle: -12 * 3.14159 / 180,
                            child: HexagonOffsetGrid.oddPointy(
                              columns: 3,
                              rows: 4,
                              buildTile: (col, row) => HexagonWidgetBuilder(
                                padding: 1.w,
                                color: Colors.transparent,
                                child: _buildHexagonButton(col, row, context),
                              ),
                            ),
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