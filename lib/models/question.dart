import 'answer.dart';

class Question {
  final String question;
  final List<Answer> answers;

  const Question({
    required this.question,
    required this.answers,
  });

  // Conversion vers JSON
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answers': answers.map((answer) => answer.toJson()).toList(),
    };
  }

  // Création depuis JSON
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      answers: (json['answers'] as List)
          .map((answerJson) => Answer.fromJson(answerJson))
          .toList(),
    );
  }
}