import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/widgets/chibi_icon_button.dart';
import 'package:oracle_d_asgard/widgets/chibi_text_button.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
    if (Platform.isIOS || Platform.isAndroid) {
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
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                      child: ClipRect(
                        child:
                            Image.asset(
                                  'assets/images/odin_chibi.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  alignment: Alignment.topCenter,
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      20.w,
                      0,
                      20.w,
                      _isBannerAdLoaded && _bannerAd != null
                          ? 20.h + _bannerAd!.size.height.toDouble()
                          : 20.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                              width: double.infinity,
                              child: ChibiTextButton(
                                text: 'main_screen_play'.tr(),
                                color: ChibiColors.buttonOrange,
                                onPressed: () {
                                  context.go('/games');
                                },
                              ),
                            )
                            .animate(delay: 800.ms)
                            .slideX(
                              begin: -0.3,
                              duration: 400.ms,
                              curve: Curves.easeOutCubic,
                            )
                            .fadeIn(duration: 300.ms),

                        SizedBox(height: 10.h),
                        Row(
                              children: [
                                Expanded(
                                  child: ChibiIconButton(
                                    color: ChibiColors.buttonRed,
                                    onPressed: () {
                                      context.go('/profile');
                                    },
                                    icon: const Icon(
                                      Icons.emoji_events,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: ChibiIconButton(
                                    color: ChibiColors.buttonGreen,
                                    onPressed: () {
                                      context.go('/settings');
                                    },
                                    icon: const Icon(
                                      Icons.settings,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                            .animate(delay: 1200.ms)
                            .slideX(
                              begin: -0.3,
                              duration: 400.ms,
                              curve: Curves.easeOutCubic,
                            )
                            .fadeIn(duration: 300.ms),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_isBannerAdLoaded && _bannerAd != null)
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
