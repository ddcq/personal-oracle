import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import '../data/app_data.dart';
import 'main_screen.dart';
import '../widgets/deity_card.dart'; // 👈 Import it
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle_d_asgard/widgets/confetti_overlay.dart';

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

    return Scaffold(
      body: ConfettiOverlay(
        controller: _confettiController,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/backgrounds/landscape.jpg'), fit: BoxFit.cover),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Félicitations !',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontFamily: 'AmaticSC',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 70.sp,
                            letterSpacing: 2.0.sp,
                            shadows: [const Shadow(blurRadius: 15.0, color: Colors.black87, offset: Offset(4.0, 4.0))],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Votre Divinité Tutélaire est :',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white70, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 32.h),
                        DeityCard(deity: deityData),

                        SizedBox(height: 32.h),

                        // Description
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

                        // Boutons d'action
                        Column(
                          children: [
                            SizedBox(
                              width: 0.8.sw,
                              child: ChibiButton(
                                text: 'Partager mon résultat',
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
                              ),
                            ),
                            SizedBox(height: 16.h),
                            SizedBox(
                              width: 0.8.sw,
                              child: ChibiButton(
                                text: 'Retour à l’accueil',
                                color: Colors.amber,
                                onPressed: () =>
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainScreen()), (route) => false),
                              ),
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
