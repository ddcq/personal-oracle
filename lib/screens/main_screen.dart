import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/profile_screen.dart';
import 'package:oracle_d_asgard/screens/quiz_screen.dart';
import 'package:oracle_d_asgard/screens/games/menu.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/backgrounds/landscape.jpg'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Center(
            child: OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.portrait) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Oracle d’Asgard',
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
                      ),
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: 0,
                              width: 1.sw, // Prend toute la largeur
                              child: ClipRect(
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  heightFactor: 0.7, // Affiche 70% de l'image
                                  child: Image.asset(
                                    'assets/images/odin_chibi.png',
                                    height: 500.h, // Hauteur réelle de l'image
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 0.8.sw,
                              child: ChibiButton(
                                text: 'Mini games',
                                color: const Color(0xFFF9A825), // Orange

                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPrincipal()));
                                },
                              ),
                            ),
                            SizedBox(height: 10.h),
                            SizedBox(
                              width: 0.8.sw,
                              child: ChibiButton(
                                text: 'Quiz',
                                color: const Color(0xFF1E88E5), // Blue

                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizScreen()));
                                },
                              ),
                            ),
                            SizedBox(height: 10.h),
                            SizedBox(
                              width: 0.8.sw,
                              child: ChibiButton(
                                text: 'Profile',
                                color: const Color(0xFFE53935), // Red

                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  // Landscape
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: ClipRect(
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      heightFactor: 0.7,
                                      child: Image.asset('assets/images/odin_chibi.png', fit: BoxFit.contain),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Oracle d’Asgard',
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
                            SizedBox(height: 20.h),
                            SizedBox(
                              width: 0.4.sw,
                              child: ChibiButton(
                                text: 'Mini games',
                                color: const Color(0xFFF9A825),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPrincipal()));
                                },
                              ),
                            ),
                            SizedBox(height: 10.h),
                            SizedBox(
                              width: 0.4.sw,
                              child: ChibiButton(
                                text: 'Quiz',
                                color: const Color(0xFF1E88E5),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizScreen()));
                                },
                              ),
                            ),
                            SizedBox(height: 10.h),
                            SizedBox(
                              width: 0.4.sw,
                              child: ChibiButton(
                                text: 'Profile',
                                color: const Color(0xFFE53935),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
