class Answer {
  final String text;
  final Map<String, int> scores;

  const Answer({
    required this.text,
    required this.scores,
  });

  // Conversion vers JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'scores': scores,
    };
  }

  // Création depuis JSON
  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      text: json['text'],
      scores: Map<String, int>.from(json['scores']),
    );
  }
}