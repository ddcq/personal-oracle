import 'dart:io';
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
    if (AppEnv.flagAds == 'enabled' && (Platform.isIOS || Platform.isAndroid)) {
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
    if (Platform.isIOS || Platform.isAndroid) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBackground(
            imagePath: 'assets/images/backgrounds/main.jpg',
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child:
                          Text(
                                'main_screen_title'.tr(),
                                textAlign: TextAlign.center,
                                style: ChibiTextStyles.appBarTitle,
                              )
                              .animate()
                              .slideY(
                                begin: -0.3,
                                duration: 800.ms,
                                curve: Curves.easeOutCubic,
                              )
                              .fadeIn(duration: 600.ms),
                    ),
                  ),
                  Expanded(
                    // Allows the image to shrink/grow
                    child: Center(
                      // Centers the image vertically
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0.w, 20.h, 0.w, 0),
                        child: ClipRect(
                          child:
                              Image.asset(
                                    'assets/images/odin_chibi.webp',
                                    fit: BoxFit.contain, // Scales down to fit
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                  )
                                  .animate(delay: 400.ms)
                                  .slideY(
                                    begin: -0.1,
                                    duration: 800.ms,
                                    curve: Curves.easeOutCubic,
                                  )
                                  .fadeIn(duration: 600.ms),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      0,
                      0,
                      0,
                      _isBannerAdLoaded && _bannerAd != null
                          ? _bannerAd!.size.height.toDouble()
                          : 0,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/wood.webp'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: SizedBox(
                        height: 180.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            EpicButton(
                              iconData: Icons.games_rounded,
                              label: 'main_screen_play'.tr(),
                              onPressed: () => context.go('/games'),
                            ),
                            EpicButton(
                              iconData: Icons.emoji_events,
                              label: 'main_screen_trophies'.tr(),
                              onPressed: () => context.go('/trophies'),
                            ),
                            EpicButton(
                              iconData: Icons.person,
                              label: 'main_screen_profile'.tr(),
                              onPressed: () => context.go('/profile'),
                            ),
                            EpicButton(
                              iconData: Icons.shopping_cart,
                              label: 'Boutique', // TODO: Add translation
                              onPressed: () => context.go('/shop'),
                            ),
                            EpicButton(
                              iconData: Icons.settings,
                              label: 'main_screen_settings'.tr(),
                              onPressed: () => context.go('/settings'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (AppEnv.flagAds == 'enabled' &&
              _isBannerAdLoaded &&
              _bannerAd != null)
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
