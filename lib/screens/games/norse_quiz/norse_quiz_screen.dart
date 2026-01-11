import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/data/norse_quiz_questions_data.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/chibi_text_button.dart';
import 'package:oracle_d_asgard/utils/chibi_theme.dart';
import 'package:easy_localization/easy_localization.dart';

class NorseQuizScreen extends StatefulWidget {
  const NorseQuizScreen({super.key});

  @override
  State<NorseQuizScreen> createState() => _NorseQuizScreenState();
}

class _NorseQuizScreenState extends State<NorseQuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  late List<NorseQuizQuestion> _questions;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;
  int _level = 1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLevelAndQuestions();
  }

  Future<void> _loadLevelAndQuestions() async {
    _level = await getIt<GamificationService>().getNorseQuizLevel();
    _setupQuestionsForLevel();
    setState(() {
      _isLoading = false;
    });
  }

  void _setupQuestionsForLevel() {
    final easyQuestions = norseQuizQuestions.where((q) => q.difficulty == QuizDifficulty.easy).toList();
    final mediumQuestions = norseQuizQuestions.where((q) => q.difficulty == QuizDifficulty.medium).toList();
    final hardQuestions = norseQuizQuestions.where((q) => q.difficulty == QuizDifficulty.hard).toList();

    easyQuestions.shuffle();
    mediumQuestions.shuffle();
    hardQuestions.shuffle();

    List<NorseQuizQuestion> selectedQuestions = [];

    if (_level == 1) {
      selectedQuestions.addAll(easyQuestions.take(10));
    } else if (_level == 2) {
      selectedQuestions.addAll(easyQuestions.take(7));
      selectedQuestions.addAll(mediumQuestions.take(3));
    } else if (_level == 3) {
      selectedQuestions.addAll(easyQuestions.take(5));
      selectedQuestions.addAll(mediumQuestions.take(5));
    } else if (_level == 4) {
      selectedQuestions.addAll(easyQuestions.take(2));
      selectedQuestions.addAll(mediumQuestions.take(8));
    } else if (_level == 5) {
      selectedQuestions.addAll(mediumQuestions.take(10));
    } else if (_level == 6) {
      selectedQuestions.addAll(mediumQuestions.take(7));
      selectedQuestions.addAll(hardQuestions.take(3));
    } else if (_level == 7) {
      selectedQuestions.addAll(mediumQuestions.take(5));
      selectedQuestions.addAll(hardQuestions.take(5));
    } else if (_level == 8) {
      selectedQuestions.addAll(mediumQuestions.take(2));
      selectedQuestions.addAll(hardQuestions.take(8));
    } else if (_level >= 9) {
      selectedQuestions.addAll(hardQuestions.take(10));
    }

    selectedQuestions.shuffle();
    _questions = selectedQuestions;
  }

  void _handleAnswer(int answerIndex) {
    if (_isAnswered) return;

    setState(() {
      _selectedAnswerIndex = answerIndex;
      _isAnswered = true;
    });

    if (answerIndex == _questions[_currentQuestionIndex].correctAnswerIndex) {
      _score++;
    }

    Timer(const Duration(seconds: 1), _nextQuestion);
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = null;
        _isAnswered = false;
      });
    } else {
      context.go('/norse_quiz/result', extra: _score);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: AppBackground(
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Niveau: $_level - Score: $_score'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/games'),
        ),
      ),
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  question.question.tr(),
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: question.options.length,
                  itemBuilder: (context, index) {
                    final option = question.options[index];
                    Color buttonColor = ChibiColors.darkEpicPurple;
                    if (_isAnswered) {
                      if (index == question.correctAnswerIndex) {
                        buttonColor = Colors.green;
                      } else if (index == _selectedAnswerIndex) {
                        buttonColor = Colors.red;
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: ChibiTextButton(
                        text: option.tr(),
                        color: buttonColor,
                        onPressed: () => _handleAnswer(index),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
