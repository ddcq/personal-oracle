import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:confetti/confetti.dart';
import 'package:oracle_d_asgard/data/app_data.dart';
import 'package:oracle_d_asgard/widgets/deity_card.dart'; // 👈 Import it
import 'package:oracle_d_asgard/widgets/chibi_icon_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              child: Center(
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
                                          fontSize: 70.sp,
                                          letterSpacing: 2.0.sp,
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
                        SizedBox(height: 16.h),
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
                        SizedBox(height: 32.h),
                        DeityCard(deity: deityData)
                            .animate(delay: 1000.ms)
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              duration: 800.ms,
                              curve: Curves.easeOutBack,
                            )
                            .fadeIn(duration: 600.ms),
                        SizedBox(height: 32.h),
                        Container(
                          width: 1.sw,
                          padding: EdgeInsets.all(24.w),
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
                              20.r,
                            ), // Slightly more rounded
                            border: Border.all(
                              color: Colors.blueGrey.shade700,
                              width: 3.w,
                            ), // More prominent border
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(
                                  150,
                                ), // Darker shadow
                                offset: Offset(
                                  0,
                                  8.h,
                                ), // More pronounced 3D effect
                                blurRadius: 12.r,
                                spreadRadius: 2.r,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'result_screen_your_profile'.tr(),
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                deityData.description.tr(),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white70,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ChibiIconButton(
                              color: const Color(0xFF1E88E5), // Blue
                              onPressed: _shareResult,
                              icon: const Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                            ),
                            ChibiIconButton(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
