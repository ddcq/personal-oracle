import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:oracle_d_asgard/services/notification_service.dart';
import 'package:oracle_d_asgard/utils/themes.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:oracle_d_asgard/services/database_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:oracle_d_asgard/services/sound_service.dart';
import 'package:oracle_d_asgard/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/router.dart'; // Import the router
import 'package:shared_preferences/shared_preferences.dart';

Future<Locale> _loadSavedLocale() async {
  final prefs = await SharedPreferences.getInstance();
  final languageCode = prefs.getString('language_code');
  final countryCode = prefs.getString('country_code');

  if (languageCode != null) {
    return Locale(languageCode, countryCode?.isNotEmpty == true ? countryCode : null);
  }

  // Valeur par défaut si aucune langue n'est sauvegardée
  return const Locale('en', 'US');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  setupLocator();
  await NotificationService().init(); // Initialize NotificationService
  if (Platform.isIOS || Platform.isAndroid) {
    await MobileAds.instance.initialize();
  }
  await getIt<DatabaseService>().database;

  // Charger la langue sauvegardée
  final savedLocale = await _loadSavedLocale();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('fr', 'FR')],
      path: 'assets/resources/langs',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: savedLocale,
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
    NotificationService().cancelAllNotifications(); // Cancel notifications on app start
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Force rebuild when locale changes from EasyLocalization
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final soundService = getIt<SoundService>();
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      soundService.pauseMusic();
      NotificationService().scheduleNotification(); // Schedule notification on app pause
    } else if (state == AppLifecycleState.resumed) {
      soundService.resumeMusic();
      NotificationService().cancelAllNotifications(); // Cancel notifications on app resume
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
          key: ValueKey(context.locale.toString()), // Force rebuild when locale changes
          title: context.locale.languageCode == 'fr' ? 'Oracle d\'Asgard' : 'Oracle of Asgard',
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
