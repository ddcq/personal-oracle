import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/data/app_data.dart';
import '../models/question.dart';
import '../services/quiz_service.dart';
import '../utils/constants.dart';
import '../widgets/answer_button.dart';
import '../widgets/progress_bar.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestion = 0;

  Map<String, int> scores = {
    for (var trait in AppConstants.personalityTraits) trait: 0,
  };

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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen(deity: deity)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (currentQuestion + 1) / AppData.questions.length;
    final Question question = AppData.questions[currentQuestion];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppConstants.primaryDark, AppConstants.secondaryDark],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProgressBar(
                  currentQuestion: currentQuestion + 1,
                  totalQuestions: AppData.questions.length,
                  progress: progress,
                ),
                const SizedBox(height: AppConstants.paddingXLarge),

                // Question
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  decoration: BoxDecoration(
                    color: AppConstants.secondaryDark,
                    borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                    border: Border.all(color: AppConstants.cardDark),
                  ),
                  child: Text(
                    question.question,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingXLarge),

                // Réponses
                Expanded(
                  child: ListView.separated(
                    itemCount: question.answers.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppConstants.paddingMedium),
                    itemBuilder: (context, index) {
                      final answer = question.answers[index];
                      return AnswerButton(
                        text: answer.text,
                        onPressed: () => handleAnswer(index),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
