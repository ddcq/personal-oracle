import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/profile_screen.dart';
import 'package:oracle_d_asgard/screens/quiz_screen.dart';
import 'package:oracle_d_asgard/screens/games/menu.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

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
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.h),
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
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                          child: ClipRect(
                            child: Image.asset(
                              'assets/images/odin_chibi.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: double.infinity,
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
                              width: double.infinity,
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
                              width: double.infinity,
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
                  final buttonTextStyle = TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5.sp,
                    color: Colors.white,
                    fontFamily: GoogleFonts.amarante().fontFamily,
                  );

                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 0.2.sh),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              'Oracle d’Asgard',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    fontFamily: 'AmaticSC',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0.sp,
                                    shadows: [const Shadow(blurRadius: 15.0, color: Colors.black87, offset: Offset(4.0, 4.0))],
                                  ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(16.w, 8.h, 8.w, 16.h),
                                child: ClipRect(
                                  child: Image.asset(
                                    'assets/images/odin_chibi.png',
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(8.w, 8.h, 16.w, 16.h),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ChibiButton(
                                      text: 'Mini games',
                                      color: const Color(0xFFF9A825),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPrincipal()));
                                      },
                                      textStyle: buttonTextStyle,
                                    ),
                                    SizedBox(height: 10.h),
                                    ChibiButton(
                                      text: 'Quiz',
                                      color: const Color(0xFF1E88E5),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizScreen()));
                                      },
                                      textStyle: buttonTextStyle,
                                    ),
                                    SizedBox(height: 10.h),
                                    ChibiButton(
                                      text: 'Profile',
                                      color: const Color(0xFFE53935),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                                      },
                                      textStyle: buttonTextStyle,
                                    ),
                                  ],
                                ),
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
