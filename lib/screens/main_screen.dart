import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/profile_screen.dart';
import 'package:oracle_d_asgard/screens/quiz_screen.dart';
import 'package:oracle_d_asgard/screens/games/menu.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/services/database_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<void> _clearAndRebuildDatabase() async {
    final dbService = DatabaseService();
    try {
      await dbService.deleteDb();
      await dbService.reinitializeDb();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Database cleared and rebuilt successfully!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to clear and rebuild database: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBackground(
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
                                style: ChibiTextStyles.appBarTitle,
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
                                    color: ChibiColors.buttonOrange,
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
                                    color: ChibiColors.buttonBlue,
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
                                    color: ChibiColors.buttonRed,
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
                                  style: ChibiTextStyles.appBarTitle,
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
                                          color: ChibiColors.buttonOrange,
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPrincipal()));
                                          },
                                        ),
                                        SizedBox(height: 10.h),
                                        ChibiButton(
                                          text: 'Quiz',
                                          color: ChibiColors.buttonBlue,
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizScreen()));
                                          },
                                        ),
                                        SizedBox(height: 10.h),
                                        ChibiButton(
                                          text: 'Profile',
                                          color: ChibiColors.buttonRed,
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                                          },
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
          Positioned(
            bottom: 10.h,
            right: 10.w,
            child: Opacity(
              opacity: 0.3,
              child: IconButton(
                icon: const Icon(Icons.settings, size: 20),
                onPressed: _clearAndRebuildDatabase,
                tooltip: 'Clear and Rebuild Database',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
