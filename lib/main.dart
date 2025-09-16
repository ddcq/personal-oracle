import 'package:flutter/material.dart';
import 'dart:io';
import 'screens/main_screen.dart'; // 👈 Nouveau fichier avec MainScreen
import 'package:oracle_d_asgard/utils/themes.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:oracle_d_asgard/services/database_service.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:oracle_d_asgard/services/sound_service.dart';
import 'package:oracle_d_asgard/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS || Platform.isAndroid) {
    await MobileAds.instance.initialize();
  }
  await DatabaseService().database;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GamificationService()),
        ChangeNotifierProvider(create: (context) => SoundService()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Provider.of<SoundService>(context, listen: false).playMainMenuMusic();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final soundService = Provider.of<SoundService>(context, listen: false);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      soundService.pauseMusic();
    } else if (state == AppLifecycleState.resumed) {
      soundService.resumeMusic();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Standard mobile design size
      minTextAdapt: false,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Oracle Nordique',
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: Provider.of<ThemeProvider>(context).themeMode,
          home: const MainScreen(), // 👈 Utilise MainScreen au lieu de WelcomeScreen
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
