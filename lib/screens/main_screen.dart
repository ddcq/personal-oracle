import 'dart:io';
import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/profile_screen.dart';
import 'package:oracle_d_asgard/screens/quiz_screen.dart';
import 'package:oracle_d_asgard/screens/games/menu.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
                              child: Text('Oracle d’Asgard', textAlign: TextAlign.center, style: ChibiTextStyles.appBarTitle),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
                              child: ClipRect(
                                child: Image.asset('assets/images/odin_chibi.png', fit: BoxFit.cover, width: double.infinity, alignment: Alignment.topCenter),
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
                                  child: ChibiButton(
                                    text: 'Amusons-nous',
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
                                    text: 'Ma divinité gardienne',
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
                                    text: 'Mes récompenses',
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
                          SizedBox(height: 16.h),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 0.2.sh),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text('Oracle d’Asgard', textAlign: TextAlign.center, style: ChibiTextStyles.appBarTitle),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 8.w, 16.h),
                                    child: ClipRect(
                                      child: Image.asset('assets/images/odin_chibi.png', fit: BoxFit.cover, alignment: Alignment.topCenter),
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
                                          text: 'Amusons-nous',
                                          color: ChibiColors.buttonOrange,
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPrincipal()));
                                          },
                                        ),
                                        SizedBox(height: 10.h),
                                        ChibiButton(
                                          text: 'Ma divinité gardienne',
                                          color: ChibiColors.buttonBlue,
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizScreen()));
                                          },
                                        ),
                                        SizedBox(height: 10.h),
                                        ChibiButton(
                                          text: 'Mes récompenses',
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
          
          if (_isBannerAdLoaded && _bannerAd != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
