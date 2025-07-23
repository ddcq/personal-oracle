import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/data/app_data.dart';
import '../models/question.dart';
import '../services/quiz_service.dart';
import '../utils/constants.dart';
import '../widgets/answer_button.dart';
import '../widgets/progress_bar.dart';
import 'result_screen.dart';

import 'package:provider/provider.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';

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
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/backgrounds/landscape.jpg'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ProgressBar(currentQuestion: currentQuestion + 1, totalQuestions: AppData.questions.length, progress: progress),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.5), // Semi-transparent background
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Text(
                    question.question,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40, // Adjusted font size for better fit within container
                      letterSpacing: 1.5,
                      shadows: [const Shadow(blurRadius: 10.0, color: Colors.black87, offset: Offset(3.0, 3.0))],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: question.answers.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final answer = question.answers[index];
                    final String letter = String.fromCharCode('A'.codeUnitAt(0) + index);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: AnswerButton(text: answer.text, onPressed: () => handleAnswer(index), letter: letter),
                    );
                  },
                ),
              ],
            ),
          ),
      ),
    );
  }
}
