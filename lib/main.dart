import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:oracle_d_asgard/services/notification_service.dart';
import 'package:oracle_d_asgard/utils/themes.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:oracle_d_asgard/services/database_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:oracle_d_asgard/services/sound_service.dart';
import 'package:oracle_d_asgard/providers/theme_provider.dart';
import 'package:provider/provider.dart';


import 'package:oracle_d_asgard/services/cache_service.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/router.dart'; // Import the router
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize EasyLocalization with error handling
  try {
    await EasyLocalization.ensureInitialized();
  } catch (e) {
    debugPrint('Failed to initialize EasyLocalization: $e');
    // Continue without localization - app will use fallback locale
  }
  
  setupLocator();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('fr', 'FR')],
      path: 'assets/resources/langs',
      fallbackLocale: const Locale('en', 'US'),
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeServicesAfterStartup();
      _loadSavedLocale();
    });
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('language_code');
      final countryCode = prefs.getString('country_code');

      if (languageCode != null && mounted) {
        final savedLocale = Locale(languageCode, countryCode?.isNotEmpty == true ? countryCode : null);
        await context.setLocale(savedLocale);
      }
    } catch (e) {
      debugPrint('Failed to load saved locale: $e');
      // Continue with default locale
    }
  }

  Future<void> _initializeServicesAfterStartup() async {
    // Initialize CacheService and validate cache
    try {
      final cacheService = getIt<CacheService>();
      await cacheService.initialize();
      await cacheService.validateCache();
    } catch (e) {
      debugPrint('Failed to initialize or validate cache: $e');
    }

    // Initialize NotificationService with timeout to prevent blocking
    try {
      await NotificationService().init().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          // Skip notifications if initialization takes too long
        },
      );
      NotificationService().cancelAllNotifications();
    } catch (e) {
      debugPrint('Failed to initialize notifications: $e');
      // Continue without notifications if initialization fails
    }
    
    // Initialize ads with error handling
    try {
      if (Platform.isIOS || Platform.isAndroid) {
        await MobileAds.instance.initialize();
      }
    } catch (e) {
      debugPrint('Failed to initialize ads: $e');
      // Continue without ads
    }
    
    // Initialize database with error handling and timeout
    try {
      await getIt<DatabaseService>().database.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('Database initialization timeout');
          throw TimeoutException('Database initialization took too long');
        },
      );
    } catch (e) {
      debugPrint('Failed to initialize database: $e');
      // Continue - database errors will be handled per-operation
    }
    
    // Start music with error handling
    try {
      getIt<SoundService>().playMainMenuMusic();
    } catch (e) {
      debugPrint('Failed to start music: $e');
      // Continue without music
    }
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
