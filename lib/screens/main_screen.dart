import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/widgets/epic_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:oracle_d_asgard/constants/app_env.dart';
import 'package:oracle_d_asgard/widgets/hexagonal_grid.dart';
import 'package:oracle_d_asgard/utils/main_screen_translations.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    if (AppEnv.flagAds == 'enabled' && !kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      _loadBannerAd();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This ensures the widget rebuilds when the locale changes
    // EasyLocalization automatically triggers this method when locale changes
    setState(() {
      // Force rebuild when locale changes
    });
  }

  @override
  void dispose() {
    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      _bannerAd?.dispose();
    }
    super.dispose();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-9329709593733606/5595843851',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  List<HexGridItem> _buildGridItems(BuildContext context) {
    final locale = context.locale.toString();
    final buttons = [
      {'icon': Icons.games_rounded, 'label': MainScreenTranslations.translate('main_screen_play', locale), 'route': '/games'},
      {'icon': Icons.emoji_events, 'label': MainScreenTranslations.translate('main_screen_trophies', locale), 'route': '/trophies'},
      //      {'icon': Icons.person, 'label': MainScreenTranslations.translate('main_screen_profile', locale), 'route': '/profile'},
      {'icon': Icons.shopping_cart, 'label': 'Boutique', 'route': '/shop'},
      {},
      {'icon': Icons.settings, 'label': MainScreenTranslations.translate('main_screen_settings', locale), 'route': '/settings'},
    ];

    return List.generate(buttons.length, (i) {
      final button = buttons[i];
      if (button.isEmpty) {
        return HexGridItem(onTap: () {}, child: const SizedBox.shrink());
      }
      return HexGridItem(
        onTap: () => context.go(button['route'] as String),
        child: EpicButton(iconData: button['icon'] as IconData, label: button['label'] as String, onPressed: () => context.go(button['route'] as String)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBackground(
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: Text(
                        MainScreenTranslations.translate('main_screen_title', context.locale.toString()),
                        textAlign: TextAlign.center,
                        style: ChibiTextStyles.appBarTitle,
                      ).animate().slideY(begin: -0.3, duration: 800.ms, curve: Curves.easeOutCubic).fadeIn(duration: 600.ms),
                    ),
                  ),
                  Expanded(
                    child: ClipRect(
                      child: Image.asset(
                        'assets/images/odin_chibi.webp',
                        fit: BoxFit.contain,
                        width: double.infinity,
                        alignment: Alignment.center,
                      ).animate(delay: 400.ms).slideY(begin: -0.1, duration: 800.ms, curve: Curves.easeOutCubic).fadeIn(duration: 600.ms),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/images/wood.webp'), fit: BoxFit.cover),
                    ),
                    child: SizedBox(
                      height: 250.h,
                      width: double.infinity,
                      child: HexagonalGrid(
                        items: _buildGridItems(context),
                        columns: 3,
                        rows: 2,
                        hexSize: 60.0,
                        skipFirstTile: true,
                        centerHorizontally: true,
                        verticalOffset: 0.3,
                        containerHeight: 250.h,
                      ),
                    ),
                  ),
                  if (_isBannerAdLoaded && _bannerAd != null) SizedBox(height: _bannerAd!.size.height.toDouble()),
                ],
              ),
            ),
          ),

          if (AppEnv.flagAds == 'enabled' && _isBannerAdLoaded && _bannerAd != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
