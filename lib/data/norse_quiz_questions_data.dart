
enum QuizDifficulty { easy, medium, hard }

class NorseQuizQuestion {
  const NorseQuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.difficulty,
  });

  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final QuizDifficulty difficulty;
}

final List<NorseQuizQuestion> norseQuizQuestions = [
  const NorseQuizQuestion(
    question: 'norse_quiz_q1',
    options: ['norse_quiz_q1_a1', 'norse_quiz_q1_a2', 'norse_quiz_q1_a3', 'norse_quiz_q1_a4'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.easy,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q2',
    options: ['norse_quiz_q2_a1', 'norse_quiz_q2_a2', 'norse_quiz_q2_a3'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.easy,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q3',
    options: ['norse_quiz_q3_a1', 'norse_quiz_q3_a2', 'norse_quiz_q3_a3'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.easy,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q4',
    options: ['norse_quiz_q4_a1', 'norse_quiz_q4_a2', 'norse_quiz_q4_a3'],
    correctAnswerIndex: 0,
    difficulty: QuizDifficulty.easy,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q5',
    options: ['norse_quiz_q5_a1', 'norse_quiz_q5_a2', 'norse_quiz_q5_a3', 'norse_quiz_q5_a4'],
    correctAnswerIndex: 3,
    difficulty: QuizDifficulty.easy,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q6',
    options: ['norse_quiz_q6_a1', 'norse_quiz_q6_a2', 'norse_quiz_q6_a3'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.easy,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q7',
    options: ['norse_quiz_q7_a1', 'norse_quiz_q7_a2', 'norse_quiz_q7_a3'],
    correctAnswerIndex: 2,
    difficulty: QuizDifficulty.easy,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q8',
    options: ['norse_quiz_q8_a1', 'norse_quiz_q8_a2', 'norse_quiz_q8_a3'],
    correctAnswerIndex: 0,
    difficulty: QuizDifficulty.easy,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q9',
    options: ['norse_quiz_q9_a1', 'norse_quiz_q9_a2', 'norse_quiz_q9_a3'],
    correctAnswerIndex: 0,
    difficulty: QuizDifficulty.easy,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q10',
    options: ['norse_quiz_q10_a1', 'norse_quiz_q10_a2'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.easy,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q11',
    options: ['norse_quiz_q11_a1', 'norse_quiz_q11_a2', 'norse_quiz_q11_a3'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.easy,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q12',
    options: ['norse_quiz_q12_a1', 'norse_quiz_q12_a2', 'norse_quiz_q12_a3'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.easy,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q13',
    options: ['norse_quiz_q13_a1', 'norse_quiz_q13_a2', 'norse_quiz_q13_a3'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.easy,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q14',
    options: ['norse_quiz_q14_a1', 'norse_quiz_q14_a2', 'norse_quiz_q14_a3'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.easy,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q15',
    options: ['norse_quiz_q15_a1', 'norse_quiz_q15_a2', 'norse_quiz_q15_a3'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.easy,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q16',
    options: ['norse_quiz_q16_a1', 'norse_quiz_q16_a2', 'norse_quiz_q16_a3'],
    correctAnswerIndex: 0,
    difficulty: QuizDifficulty.easy,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q17',
    options: ['norse_quiz_q17_a1', 'norse_quiz_q17_a2'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.easy,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q18',
    options: ['norse_quiz_q18_a1', 'norse_quiz_q18_a2'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.easy,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q19',
    options: ['norse_quiz_q19_a1', 'norse_quiz_q19_a2', 'norse_quiz_q19_a3'],
    correctAnswerIndex: 0,
    difficulty: QuizDifficulty.easy,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q20',
    options: ['norse_quiz_q20_a1', 'norse_quiz_q20_a2', 'norse_quiz_q20_a3'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.easy,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q21',
    options: ['norse_quiz_q21_a1', 'norse_quiz_q21_a2', 'norse_quiz_q21_a3'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.medium,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q22',
    options: ['norse_quiz_q22_a1', 'norse_quiz_q22_a2', 'norse_quiz_q22_a3'],
    correctAnswerIndex: 0,
    difficulty: QuizDifficulty.medium,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q23',
    options: ['norse_quiz_q23_a1', 'norse_quiz_q23_a2', 'norse_quiz_q23_a3'],
    correctAnswerIndex: 0,
    difficulty: QuizDifficulty.medium,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q24',
    options: ['norse_quiz_q24_a1', 'norse_quiz_q24_a2', 'norse_quiz_q24_a3'],
    correctAnswerIndex: 0,
    difficulty: QuizDifficulty.medium,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q25',
    options: ['norse_quiz_q25_a1', 'norse_quiz_q25_a2', 'norse_quiz_q25_a3'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.medium,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q26',
    options: ['norse_quiz_q26_a1', 'norse_quiz_q26_a2', 'norse_quiz_q26_a3'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.medium,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q27',
    options: ['norse_quiz_q27_a1', 'norse_quiz_q27_a2', 'norse_quiz_q27_a3'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.medium,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q28',
    options: ['norse_quiz_q28_a1', 'norse_quiz_q28_a2', 'norse_quiz_q28_a3'],
    correctAnswerIndex: 0,
    difficulty: QuizDifficulty.medium,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q29',
    options: ['norse_quiz_q29_a1', 'norse_quiz_q29_a2', 'norse_quiz_q29_a3'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.medium,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q30',
    options: ['norse_quiz_q30_a1', 'norse_quiz_q30_a2'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.medium,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q31',
    options: ['norse_quiz_q31_a1', 'norse_quiz_q31_a2', 'norse_quiz_q31_a3'],
    correctAnswerIndex: 0,
    difficulty: QuizDifficulty.medium,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q32',
    options: ['norse_quiz_q32_a1', 'norse_quiz_q32_a2', 'norse_quiz_q32_a3'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.medium,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q33',
    options: ['norse_quiz_q33_a1', 'norse_quiz_q33_a2', 'norse_quiz_q33_a3'],
    correctAnswerIndex: 0,
    difficulty: QuizDifficulty.medium,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q34',
    options: ['norse_quiz_q34_a1', 'norse_quiz_q34_a2'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.medium,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q35',
    options: ['norse_quiz_q35_a1', 'norse_quiz_q35_a2'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.medium,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q36',
    options: ['norse_quiz_q36_a1', 'norse_quiz_q36_a2'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.medium,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q37',
    options: ['norse_quiz_q37_a1', 'norse_quiz_q37_a2'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.medium,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q38',
    options: ['norse_quiz_q38_a1', 'norse_quiz_q38_a2', 'norse_quiz_q38_a3'],
    correctAnswerIndex: 0,
    difficulty: QuizDifficulty.medium,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q39',
    options: ['norse_quiz_q39_a1', 'norse_quiz_q39_a2', 'norse_quiz_q39_a3'],
    correctAnswerIndex: 0,
    difficulty: QuizDifficulty.medium,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q40',
    options: ['norse_quiz_q40_a1', 'norse_quiz_q40_a2'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.medium,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q41',
    options: ['norse_quiz_q41_a1', 'norse_quiz_q41_a2', 'norse_quiz_q41_a3'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.hard,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q42',
    options: ['norse_quiz_q42_a1', 'norse_quiz_q42_a2', 'norse_quiz_q42_a3'],
    correctAnswerIndex: 0,
    difficulty: QuizDifficulty.hard,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q43',
    options: ['norse_quiz_q43_a1', 'norse_quiz_q43_a2', 'norse_quiz_q43_a3'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.hard,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q44',
    options: ['norse_quiz_q44_a1', 'norse_quiz_q44_a2', 'norse_quiz_q44_a3'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.hard,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q45',
    options: ['norse_quiz_q45_a1', 'norse_quiz_q45_a2'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.hard,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q46',
    options: ['norse_quiz_q46_a1', 'norse_quiz_q46_a2'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.hard,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q47',
    options: ['norse_quiz_q47_a1', 'norse_quiz_q47_a2'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.hard,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q48',
    options: ['norse_quiz_q48_a1', 'norse_quiz_q48_a2'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.hard,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q49',
    options: ['norse_quiz_q49_a1', 'norse_quiz_q49_a2', 'norse_quiz_q49_a3'],
    correctAnswerIndex: 0,
    difficulty: QuizDifficulty.hard,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q50',
    options: ['norse_quiz_q50_a1', 'norse_quiz_q50_a2'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.hard,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q51',
    options: ['norse_quiz_q51_a1', 'norse_quiz_q51_a2', 'norse_quiz_q51_a3'],
    correctAnswerIndex: 0,
    difficulty: QuizDifficulty.hard,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q52',
    options: ['norse_quiz_q52_a1', 'norse_quiz_q52_a2', 'norse_quiz_q52_a3'],
    correctAnswerIndex: 0,
    difficulty: QuizDifficulty.hard,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q53',
    options: ['norse_quiz_q53_a1', 'norse_quiz_q53_a2'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.hard,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q54',
    options: ['norse_quiz_q54_a1', 'norse_quiz_q54_a2'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.hard,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q55',
    options: ['norse_quiz_q55_a1', 'norse_quiz_q55_a2'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.hard,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q56',
    options: ['norse_quiz_q56_a1', 'norse_quiz_q56_a2', 'norse_quiz_q56_a3'],
    correctAnswerIndex: 2,
    difficulty: QuizDifficulty.hard,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q57',
    options: ['norse_quiz_q57_a1', 'norse_quiz_q57_a2'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.hard,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q58',
    options: ['norse_quiz_q58_a1', 'norse_quiz_q58_a2', 'norse_quiz_q58_a3'],
    correctAnswerIndex: 0,
    difficulty: QuizDifficulty.hard,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q59',
    options: ['norse_quiz_q59_a1', 'norse_quiz_q59_a2'],
    correctAnswerIndex: 1,
    difficulty: QuizDifficulty.hard,
  ),
  const NorseQuizQuestion(
    question: 'norse_quiz_q60',
    options: ['norse_quiz_q60_a1', 'norse_quiz_q60_a2', 'norse_quiz_q60_a3'],
    correctAnswerIndex: 0,
    difficulty: QuizDifficulty.hard,
  ),
];
