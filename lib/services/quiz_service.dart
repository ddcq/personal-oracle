import 'package:oracle_d_asgard/models/deity.dart';
import 'package:oracle_d_asgard/models/question.dart';
import 'package:oracle_d_asgard/models/answer.dart';
import 'package:oracle_d_asgard/data/app_data.dart';
import 'package:oracle_d_asgard/utils/constants.dart';

class QuizService {
  static List<Question> getQuestions() {
    return AppData.questions;
  }

  static Map<String, Deity> getDeities() {
    return AppData.deities;
  }

  static Map<String, int> initializeScores() {
    Map<String, int> scores = {};
    for (String trait in AppConstants.personalityTraits) {
      scores[trait] = 0;
    }
    return scores;
  }

  static void updateScores(Map<String, int> currentScores, Answer answer) {
    answer.scores.forEach((trait, points) {
      currentScores[trait] = (currentScores[trait] ?? 0) + points;
    });
  }

  static List<String> getAllowedQuizDeityIds() {
    return ['odin', 'loki', 'freyja', 'frigg', 'thor', 'tyr'];
  }

  static String calculateBestDeity(Map<String, int> scores) {
    String bestMatch = 'odin';
    int bestScore = -1;

    final List<String> allowedDeityIds = getAllowedQuizDeityIds();

    AppData.deities.forEach((key, deity) {
      if (!allowedDeityIds.contains(key)) {
        return; // Skip if not an allowed deity
      }
      int matchScore = 0;
      deity.traits.forEach((trait, weight) {
        matchScore += (scores[trait] ?? 0) * weight;
      });
      
      if (matchScore > bestScore) {
        bestScore = matchScore;
        bestMatch = key;
      }
    });

    return bestMatch;
  }

  static Deity? getDeityById(String deityId) {
    return AppData.deities[deityId];
  }

  static double calculateProgress(int currentQuestion, int totalQuestions) {
    return (currentQuestion + 1) / totalQuestions;
  }

  static bool isLastQuestion(int currentQuestion, int totalQuestions) {
    return currentQuestion >= totalQuestions - 1;
  }
}