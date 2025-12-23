class QuizResult {
  final int correctAnswersCount;
  final int totalQuestions;
  final int durationInSeconds;
  final String subjectName;

  QuizResult({
    required this.correctAnswersCount,
    required this.totalQuestions,
    required this.durationInSeconds,
    required this.subjectName,
  });

  double get percentageCorrect => totalQuestions > 0
      ? correctAnswersCount / totalQuestions
      : 0;

  double get percentageWrong => 1 - percentageCorrect;

  int get incorrectAnswersCount => totalQuestions - correctAnswersCount;
}