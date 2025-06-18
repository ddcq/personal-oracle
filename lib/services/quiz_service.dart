import '../models/deity.dart';
import '../models/question.dart';
import '../models/answer.dart';
import '../data/app_data.dart';
import '../utils/constants.dart';

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

  static String calculateBestDeity(Map<String, int> scores) {
    String bestMatch = 'odin';
    int bestScore = -1;

    AppData.deities.forEach((key, deity) {
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