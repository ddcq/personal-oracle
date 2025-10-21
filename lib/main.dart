import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:oracle_d_asgard/utils/themes.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:oracle_d_asgard/services/database_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:oracle_d_asgard/services/sound_service.dart';
import 'package:oracle_d_asgard/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/router.dart'; // Import the router

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  setupLocator();
  if (Platform.isIOS || Platform.isAndroid) {
    await MobileAds.instance.initialize();
  }
  await getIt<DatabaseService>().database;
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('fr', 'FR')],
      path: 'assets/resources/langs',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: const Locale('en', 'US'),
      child: ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MyApp(),
      ),
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
    getIt<SoundService>().playMainMenuMusic();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final soundService = getIt<SoundService>();
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
        return MaterialApp.router(
          title: 'Oracle Nordique',
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: Provider.of<ThemeProvider>(context).themeMode,
          routerConfig: router, // Use routerConfig instead of home and routes
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
