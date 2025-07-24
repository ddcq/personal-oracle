import 'package:flutter/material.dart';
import 'screens/main_screen.dart'; // 👈 Nouveau fichier avec MainScreen
import 'utils/constants.dart';

import 'package:oracle_d_asgard/services/database_service.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService().database;
  runApp(ChangeNotifierProvider(create: (context) => GamificationService(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Standard mobile design size
      minTextAdapt: false,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Oracle Nordique',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: AppConstants.primaryDark,
            textTheme: TextTheme(
              headlineLarge: TextStyle(color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.bold),
              headlineSmall: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w600),
              bodyMedium: TextStyle(color: Colors.white70, fontSize: 16.sp),
              bodySmall: TextStyle(color: Colors.white60, fontSize: 14.sp),
            ),
            cardTheme: CardThemeData(color: Colors.white.withAlpha(25), elevation: 4),
          ),
          home: const MainScreen(), // 👈 Utilise MainScreen au lieu de WelcomeScreen
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
