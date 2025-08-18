import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/data/app_data.dart';
import '../models/question.dart';
import '../services/quiz_service.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/answer_button.dart';
import '../widgets/progress_bar.dart';
import 'result_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:provider/provider.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestion = 0;

  Map<String, int> scores = {for (var trait in AppConstants.personalityTraits) trait: 0};

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
      _navigateToResult();
    }
  }

  void _navigateToResult() {
    final deity = QuizService.calculateBestDeity(scores);
    Provider.of<GamificationService>(context, listen: false).saveQuizResult(deity);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResultScreen(deity: deity)));
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
        title: Text(
          'Question ${currentQuestion + 1} sur ${AppData.questions.length}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/backgrounds/landscape.jpg'), fit: BoxFit.cover),
        ),
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

                          return Padding(
                            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
                            child: AnswerButton(
                              text: answer.text,
                              onPressed: () => handleAnswer(index),
                              letter: letter,
                              gradientColors: gradientColors,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20.h),
                    ProgressBar(progress: progress),
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
