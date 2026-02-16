import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:confetti/confetti.dart';
import 'package:oracle_d_asgard/data/app_data.dart';
import 'package:oracle_d_asgard/widgets/deity_card.dart'; // 👈 Import it
import 'package:oracle_d_asgard/widgets/epic_icon_button.dart';
import 'package:oracle_d_asgard/providers/responsive_provider.dart';
import 'package:oracle_d_asgard/widgets/confetti_overlay.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ResultScreen extends StatefulWidget {
  final String deity;

  const ResultScreen({super.key, required this.deity});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _shareResult() {
    final deityData = AppData.deities[widget.deity]!;
    SharePlus.instance.share(
      ShareParams(
        text: 'result_screen_share_text'.tr(
          namedArgs: {
            'deity': deityData.name,
            'description': deityData.description.tr(),
            'link':
                'https://play.google.com/store/apps/details?id=net.forhimandus.oracledasgard',
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deityData = AppData.deities[widget.deity]!;

    return Scaffold(
      body: ConfettiOverlay(
        controller: _confettiController,
        child: Stack(
          children: [
            AppBackground(
              child: Builder(
                builder: (context) {
                  final responsive = Responsive(context);
                  return Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FittedBox(
                              fit: BoxFit.contain,
                              child:
                                  Text(
                                        'result_screen_congratulations'.tr(),
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(
                                              fontFamily: AppTextStyles.amaticSC,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: responsive.sp(70),
                                              letterSpacing: responsive.sp(2.0),
                                              shadows: [
                                                const Shadow(
                                                  blurRadius: 15.0,
                                                  color: Colors.black87,
                                                  offset: Offset(4.0, 4.0),
                                                ),
                                              ],
                                            ),
                                      )
                                      .animate(delay: 200.ms)
                                      .slideY(
                                        begin: -0.3,
                                        duration: 800.ms,
                                        curve: Curves.easeOutBack,
                                      )
                                      .fadeIn(duration: 600.ms),
                            ),
                            SizedBox(height: responsive.height(16)),
                            Text(
                                  'result_screen_guardian_deity_is'.tr(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          const Shadow(
                                            blurRadius: 10.0,
                                            color: Colors.black,
                                            offset: Offset(2.0, 2.0),
                                          ),
                                        ],
                                      ),
                                )
                                .animate(delay: 600.ms)
                                .slideY(
                                  begin: -0.2,
                                  duration: 600.ms,
                                  curve: Curves.easeOutCubic,
                                )
                                .fadeIn(duration: 400.ms),
                            SizedBox(height: responsive.height(32)),
                            DeityCard(deity: deityData)
                                .animate(delay: 1000.ms)
                                .scale(
                                  begin: const Offset(0.8, 0.8),
                                  duration: 800.ms,
                                  curve: Curves.easeOutBack,
                                )
                                .fadeIn(duration: 600.ms),
                            SizedBox(height: responsive.height(32)),
                            Container(
                              width: responsive.gameSize.width,
                              padding: EdgeInsets.all(responsive.width(24)),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blueGrey.shade800,
                                    Colors.blueGrey.shade900,
                                  ], // Darker, muted gradient
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(
                                  responsive.width(20),
                                ), // Slightly more rounded
                                border: Border.all(
                                  color: Colors.blueGrey.shade700,
                                  width: responsive.width(3),
                                ), // More prominent border
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(
                                      150,
                                    ), // Darker shadow
                                    offset: Offset(
                                      0,
                                      responsive.height(8),
                                    ), // More pronounced 3D effect
                                    blurRadius: responsive.width(12),
                                    spreadRadius: responsive.width(2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'result_screen_your_profile'.tr(),
                                    style: TextStyle(
                                      fontSize: responsive.sp(20),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  SizedBox(height: responsive.height(16)),
                                  Text(
                                    deityData.description.tr(),
                                    style: TextStyle(
                                      fontSize: responsive.sp(16),
                                      color: Colors.white70,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: responsive.height(24)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                EpicIconButton(
                                  color: const Color(0xFF1E88E5), // Blue
                                  onPressed: _shareResult,
                                  icon: const Icon(
                                    Icons.share,
                                    color: Colors.white,
                                  ),
                                ),
                                EpicIconButton(
                                  color: Colors.amber,
                                  onPressed: () {
                                    // Force navigation to home
                                    while (GoRouter.of(context).canPop()) {
                                      GoRouter.of(context).pop();
                                    }
                                    GoRouter.of(context).go('/');
                                  },
                                  icon: const Icon(Icons.home, color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
