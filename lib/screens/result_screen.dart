import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:oracle_d_asgard/data/app_data.dart';
import 'package:oracle_d_asgard/widgets/deity_card.dart'; // 👈 Import it
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
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
    _confettiController = ConfettiController(duration: const Duration(seconds: 5));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deityData = AppData.deities[widget.deity]!;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: ConfettiOverlay(
        controller: _confettiController,
        child: Stack(
          children: [
            AppBackground(
              child: Center(
                child: isLandscape
                    ? Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        'Félicitations !',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                          fontFamily: AppTextStyles.amaticSC,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 50.sp,
                                          letterSpacing: 2.0.sp,
                                          shadows: [const Shadow(blurRadius: 15.0, color: Colors.black87, offset: Offset(4.0, 4.0))],
                                        ),
                                      )
                                        .animate(delay: 200.ms)
                                        .slideY(begin: -0.3, duration: 800.ms, curve: Curves.easeOutBack)
                                        .fadeIn(duration: 600.ms),
                                    ),
                                    SizedBox(height: 8.h),
                                    Container(
                                      padding: EdgeInsets.all(4.w),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Colors.blueGrey.shade800, Colors.blueGrey.shade900],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(20.r),
                                        border: Border.all(color: Colors.blueGrey.shade700, width: 3.w),
                                        boxShadow: [BoxShadow(color: Colors.black.withAlpha(150), offset: Offset(0, 8.h), blurRadius: 12.r, spreadRadius: 2.r)],
                                      ),
                                      child: Text(
                                        deityData.description,
                                        style: TextStyle(fontSize: 0.05 * 1.sh, color: Colors.white70, height: 1.5),
                                      ),
                                    )
                                      .animate(delay: 1000.ms)
                                      .slideX(begin: -0.2, duration: 600.ms, curve: Curves.easeOutCubic)
                                      .fadeIn(duration: 400.ms),
                                    SizedBox(height: 16.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: ChibiButton(
                                            color: const Color(0xFF1E88E5),
                                            onPressed: () {
                                              SharePlus.instance.share(
                                                ShareParams(
                                                  text:
                                                      'J\'ai découvert ma divinité tutélaire dans Oracle d\'Asgard : ${deityData.name} !\n\n${deityData.description}\n\nRejoignez-moi pour découvrir la vôtre !',
                                                ),
                                              );
                                            },
                                            child: const Icon(Icons.share, color: Colors.white),
                                          )
                                            .animate(delay: 1400.ms)
                                            .slideY(begin: 0.3, duration: 500.ms, curve: Curves.easeOutBack)
                                            .fadeIn(duration: 300.ms),
                                        ),
                                        SizedBox(width: 16.w),
                                        Expanded(
                                          child: ChibiButton(
                                            color: Colors.amber,
                                            onPressed: () {
                                              // Force navigation to home
                                              while (GoRouter.of(context).canPop()) {
                                                GoRouter.of(context).pop();
                                              }
                                              GoRouter.of(context).go('/');
                                            },
                                            child: const Icon(Icons.home, color: Colors.white),
                                          )
                                            .animate(delay: 1600.ms)
                                            .slideY(begin: 0.3, duration: 500.ms, curve: Curves.easeOutBack)
                                            .fadeIn(duration: 300.ms),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Ta divinité gardienne est :',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        shadows: [const Shadow(blurRadius: 10.0, color: Colors.black, offset: Offset(2.0, 2.0))],
                                      ),
                                    )
                                      .animate(delay: 400.ms)
                                      .slideX(begin: 0.3, duration: 600.ms, curve: Curves.easeOutCubic)
                                      .fadeIn(duration: 400.ms),
                                    SizedBox(height: 16.h),
                                    DeityCard(deity: deityData)
                                      .animate(delay: 800.ms)
                                      .scale(begin: const Offset(0.8, 0.8), duration: 800.ms, curve: Curves.easeOutBack)
                                      .fadeIn(duration: 600.ms),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  'Félicitations !',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    fontFamily: AppTextStyles.amaticSC,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 70.sp,
                                    letterSpacing: 2.0.sp,
                                    shadows: [const Shadow(blurRadius: 15.0, color: Colors.black87, offset: Offset(4.0, 4.0))],
                                  ),
                                )
                                  .animate(delay: 200.ms)
                                  .slideY(begin: -0.3, duration: 800.ms, curve: Curves.easeOutBack)
                                  .fadeIn(duration: 600.ms),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'Ta divinité gardienne est :',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  shadows: [const Shadow(blurRadius: 10.0, color: Colors.black, offset: Offset(2.0, 2.0))],
                                ),
                              )
                                .animate(delay: 600.ms)
                                .slideY(begin: -0.2, duration: 600.ms, curve: Curves.easeOutCubic)
                                .fadeIn(duration: 400.ms),
                              SizedBox(height: 32.h),
                              DeityCard(deity: deityData)
                                .animate(delay: 1000.ms)
                                .scale(begin: const Offset(0.8, 0.8), duration: 800.ms, curve: Curves.easeOutBack)
                                .fadeIn(duration: 600.ms),
                              SizedBox(height: 32.h),
                              Container(
                                width: 1.sw,
                                padding: EdgeInsets.all(24.w),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.blueGrey.shade800, Colors.blueGrey.shade900], // Darker, muted gradient
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20.r), // Slightly more rounded
                                  border: Border.all(color: Colors.blueGrey.shade700, width: 3.w), // More prominent border
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(150), // Darker shadow
                                      offset: Offset(0, 8.h), // More pronounced 3D effect
                                      blurRadius: 12.r,
                                      spreadRadius: 2.r,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Votre Profil',
                                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.amber),
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      deityData.description,
                                      style: TextStyle(fontSize: 16.sp, color: Colors.white70, height: 1.5),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ChibiButton(
                                    color: const Color(0xFF1E88E5), // Blue
                                    onPressed: () {
                                      // Implement sharing functionality
                                      SharePlus.instance.share(
                                        ShareParams(
                                          text:
                                              'J\'ai découvert ma divinité tutélaire dans Oracle d\'Asgard : ${deityData.name} !\n\n${deityData.description}\n\nRejoignez-moi pour découvrir la vôtre !',
                                        ),
                                      );
                                    },
                                    child: const Icon(Icons.share, color: Colors.white),
                                  ),
                                  ChibiButton(
                                    color: Colors.amber,
                                    onPressed: () {
                                      // Force navigation to home
                                      while (GoRouter.of(context).canPop()) {
                                        GoRouter.of(context).pop();
                                      }
                                      GoRouter.of(context).go('/');
                                    },
                                    child: const Icon(Icons.home, color: Colors.white),
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

  /// A custom Path to paint stars. Only for ConfettiWidget
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final Path path = Path();
    final fullAngle = degToRad(360);
    final singleAngle = fullAngle / numberOfPoints;
    final halfAngle = singleAngle / 2;

    for (int i = 0; i < numberOfPoints; i++) {
      final angle = (i * singleAngle);
      path.lineTo(externalRadius * cos(angle), externalRadius * sin(angle));
      path.lineTo(internalRadius * cos(angle + halfAngle), internalRadius * sin(angle + halfAngle));
    }
    path.close();
    return path;
  }
}
