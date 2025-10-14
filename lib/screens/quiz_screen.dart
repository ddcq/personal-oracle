import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/data/app_data.dart';
import 'package:oracle_d_asgard/models/question.dart';
import 'package:oracle_d_asgard/services/quiz_service.dart';
import 'package:oracle_d_asgard/utils/colors.dart';
import 'package:oracle_d_asgard/utils/constants.dart';
import 'package:oracle_d_asgard/widgets/answer_button.dart';
import 'package:oracle_d_asgard/widgets/progress_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  InterstitialAd? _interstitialAd;
  int currentQuestion = 0;

  Map<String, int> scores = {for (var trait in AppConstants.personalityTraits) trait: 0};

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS || Platform.isAndroid) {
      _loadInterstitialAd();
    }
  }

  @override
  void dispose() {
    if (Platform.isIOS || Platform.isAndroid) {
      _interstitialAd?.dispose();
    }
    super.dispose();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-9329709593733606/2265869288',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  void handleAnswer(int answerIndex) {
    final answer = AppData.questions[currentQuestion].answers[answerIndex];

    setState(() {
      answer.scores.forEach((trait, points) {
        scores[trait] = (scores[trait] ?? 0) + points;
      });
    });

    if (currentQuestion < AppData.questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      if (_interstitialAd != null) {
        _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            _navigateToResult();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            _navigateToResult();
          },
        );
        _interstitialAd!.show();
      } else {
        _navigateToResult();
      }
    }
  }

  void _navigateToResult() {
    final deity = QuizService.calculateBestDeity(scores);
    getIt<GamificationService>().saveQuizResult(deity);
    context.go('/result', extra: deity);
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (currentQuestion + 1) / AppData.questions.length;
    final Question question = AppData.questions[currentQuestion];
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: isLandscape ? null : ProgressBar(progress: progress),
      ),
      body: AppBackground(
        child: isLandscape
            ? Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        ProgressBar(progress: progress),
                        Container(
                          padding: EdgeInsets.all(20.w),
                          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.w),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(0, 0, 0, 0.5), // Semi-transparent background
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: AutoSizeText(
                            question.question,
                            textAlign: TextAlign.center,
                            maxLines: 4, // Allow multiple lines for questions
                            minFontSize: 10.0,
                            stepGranularity: 1.0,
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp, // Max font size
                              shadows: [const Shadow(blurRadius: 10.0, color: Colors.black87, offset: Offset(3.0, 3.0))],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: question.answers.length,
                      separatorBuilder: (context, index) => SizedBox(height: 15.h),
                      itemBuilder: (context, index) {
                        final answer = question.answers[index];
                        final String letter = String.fromCharCode('A'.codeUnitAt(0) + index);
                        final traits = answer.scores.keys.toList();
                        final gradientColors = traits.isNotEmpty ? TraitColors.gradients[traits.first] : null;

                        return AnswerButton(
                          text: answer.text,
                          onPressed: () => handleAnswer(index),
                          letter: letter,
                          gradientColors: gradientColors,
                          isLandscape: isLandscape,
                        );
                      },
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20.w),
                    margin: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(0, 0, 0, 0.5), // Semi-transparent background
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: AutoSizeText(
                      question.question,
                      textAlign: TextAlign.center,
                      maxLines: 4, // Allow multiple lines for questions
                      minFontSize: 10.0,
                      stepGranularity: 1.0,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp, // Max font size
                        shadows: [const Shadow(blurRadius: 10.0, color: Colors.black87, offset: Offset(3.0, 3.0))],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: question.answers.length,
                      separatorBuilder: (context, index) => SizedBox(height: 5.h),
                      itemBuilder: (context, index) {
                        final answer = question.answers[index];
                        final String letter = String.fromCharCode('A'.codeUnitAt(0) + index);
                        final traits = answer.scores.keys.toList();
                        final gradientColors = traits.isNotEmpty ? TraitColors.gradients[traits.first] : null;

                        return Padding(
                          padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
                          child: AnswerButton(
                            text: answer.text,
                            onPressed: () => handleAnswer(index),
                            letter: letter,
                            gradientColors: gradientColors,
                            isLandscape: isLandscape,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
