/// Represents the complete result of a quiz with scores, timing, and metadata.
///
/// This model encapsulates all relevant data from a completed quiz, including
/// scores, completion time, subject information, and calculated metrics.
/// It's used by [ResultPage] to display comprehensive quiz results and
/// by [AnimatedQuizChart] for visualizations.
///
/// ## Usage
/// ```dart
/// final quizResult = QuizResult(
///   correctAnswersCount: 8,
///   totalQuestions: 10,
///   durationInSeconds: 120,
///   subjectName: 'Mathematics',
/// );
///
/// print('Score: ${quizResult.percentageCorrect * 100}%'); // 80.0%
/// print('Time: ${quizResult.durationInSeconds} seconds'); // 120
/// print('Subject: ${quizResult.subjectName}'); // Mathematics
/// ```
///
/// ## Features
/// - Calculates percentage scores automatically
/// - Provides both correct and incorrect answer counts
/// - Formats time for display
/// - Supports comparison between quiz attempts
class QuizResult {
  /// The number of questions answered correctly in the quiz.
  ///
  /// Must be a non-negative integer.
  /// Must be less than or equal to [totalQuestions].
  ///
  /// Example: If a quiz has 10 questions and 7 were correct,
  /// this value would be 7.
  final int correctAnswersCount;

  /// The total number of questions in the quiz.
  ///
  /// Must be a non-negative integer.
  /// Used to calculate percentages and validate [correctAnswersCount].
  ///
  /// Example: A quiz with 10 questions would have this value as 10.
  /// Note: Can be 0 for empty quizzes.
  final int totalQuestions;

  /// The time taken to complete the quiz, in seconds.
  ///
  /// Must be a non-negative integer.
  /// Represents the total elapsed time from start to completion.
  ///
  /// Example: If a quiz took 2 minutes and 15 seconds,
  /// this value would be 135.
  final int durationInSeconds;

  /// The name or category of the quiz subject.
  ///
  /// Used for labeling and categorizing quiz results.
  /// Should be descriptive (e.g., 'Mathematics', 'Science', 'History').
  ///
  /// Example: 'Advanced Calculus' or 'World History 101'
  final String subjectName;

  /// Creates a [QuizResult] instance with quiz data.
  ///
  /// All parameters are required. The constructor validates that
  /// [correctAnswersCount] does not exceed [totalQuestions].
  ///
  /// ## Parameters
  /// - [correctAnswersCount]: Number of correct answers (0 to [totalQuestions])
  /// - [totalQuestions]: Total number of questions (must be >= 0)
  /// - [durationInSeconds]: Completion time in seconds (must be >= 0)
  /// - [subjectName]: Name of the quiz subject
  ///
  /// ## Throws
  /// - [ArgumentError] if [totalQuestions] is negative
  /// - [ArgumentError] if [correctAnswersCount] is negative or exceeds [totalQuestions]
  /// - [ArgumentError] if [durationInSeconds] is negative
  ///
  /// ## Example
  /// ```dart
  /// try {
  ///   final result = QuizResult(
  ///     correctAnswersCount: 7,
  ///     totalQuestions: 10,
  ///     durationInSeconds: 150,
  ///     subjectName: 'Physics',
  ///   );
  /// } catch (e) {
  ///   print('Invalid quiz result: $e');
  /// }
  /// ```
  QuizResult({
    required this.correctAnswersCount,
    required this.totalQuestions,
    required this.durationInSeconds,
    required this.subjectName,
  }) {
    // Input validation
    if (totalQuestions < 0) {
      // Changed from <= 0 to < 0 to allow zero
      throw ArgumentError(
          'totalQuestions must be non-negative, got $totalQuestions');
    }
    if (correctAnswersCount < 0) {
      throw ArgumentError(
          'correctAnswersCount cannot be negative, got $correctAnswersCount');
    }
    if (correctAnswersCount > totalQuestions) {
      throw ArgumentError(
        'correctAnswersCount ($correctAnswersCount) cannot exceed totalQuestions ($totalQuestions)',
      );
    }
    if (durationInSeconds < 0) {
      throw ArgumentError(
          'durationInSeconds cannot be negative, got $durationInSeconds');
    }
  }

  /// The percentage of correct answers, expressed as a decimal between 0.0 and 1.0.
  ///
  /// Calculated as [correctAnswersCount] ÷ [totalQuestions].
  /// Returns 0.0 if [totalQuestions] is 0.
  ///
  /// ## Example
  /// ```dart
  /// final result = QuizResult(
  ///   correctAnswersCount: 3,
  ///   totalQuestions: 4,
  ///   durationInSeconds: 60,
  ///   subjectName: 'Test',
  /// );
  /// print(result.percentageCorrect); // 0.75
  /// ```
  double get percentageCorrect =>
      totalQuestions > 0 ? correctAnswersCount / totalQuestions : 0.0;

  /// The percentage of incorrect answers, expressed as a decimal between 0.0 and 1.0.
  ///
  /// Calculated as 1 - [percentageCorrect].
  /// Always complements [percentageCorrect] to total 1.0.
  ///
  /// ## Example
  /// ```dart
  /// final result = QuizResult(
  ///   correctAnswersCount: 7,
  ///   totalQuestions: 10,
  ///   durationInSeconds: 90,
  ///   subjectName: 'Test',
  /// );
  /// print(result.percentageWrong); // 0.3
  /// print(result.percentageCorrect + result.percentageWrong); // 1.0
  /// ```
  double get percentageWrong => 1 - percentageCorrect;

  /// The number of questions answered incorrectly.
  ///
  /// Calculated as [totalQuestions] - [correctAnswersCount].
  /// Always a non-negative integer.
  ///
  /// ## Example
  /// ```dart
  /// final result = QuizResult(
  ///   correctAnswersCount: 8,
  ///   totalQuestions: 12,
  ///   durationInSeconds: 180,
  ///   subjectName: 'Chemistry',
  /// );
  /// print(result.incorrectAnswersCount); // 4
  /// ```
  int get incorrectAnswersCount => totalQuestions - correctAnswersCount;

  /// Formats the duration as a human-readable string (MM:SS).
  ///
  /// Converts [durationInSeconds] to minutes and seconds format.
  ///
  /// ## Returns
  /// A string in the format 'MM:SS' (e.g., '02:15' for 135 seconds).
  ///
  /// ## Example
  /// ```dart
  /// final result = QuizResult(
  ///   correctAnswersCount: 5,
  ///   totalQuestions: 5,
  ///   durationInSeconds: 125,
  ///   subjectName: 'Quick Test',
  /// );
  /// print(result.formattedDuration); // '02:05'
  /// ```
  String get formattedDuration {
    final minutes = (durationInSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (durationInSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Creates a copy of this [QuizResult] with updated values.
  ///
  /// Useful for creating modified versions of existing quiz results.
  ///
  /// ## Example
  /// ```dart
  /// final original = QuizResult(
  ///   correctAnswersCount: 5,
  ///   totalQuestions: 10,
  ///   durationInSeconds: 120,
  ///   subjectName: 'Math',
  /// );
  ///
  /// final updated = original.copyWith(
  ///   subjectName: 'Advanced Math',
  ///   durationInSeconds: 150,
  /// );
  /// ```
  QuizResult copyWith({
    int? correctAnswersCount,
    int? totalQuestions,
    int? durationInSeconds,
    String? subjectName,
  }) {
    return QuizResult(
      correctAnswersCount: correctAnswersCount ?? this.correctAnswersCount,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
      subjectName: subjectName ?? this.subjectName,
    );
  }

  /// Converts the quiz result to a JSON-serializable map.
  ///
  /// Useful for saving quiz results to local storage or sending to APIs.
  ///
  /// ## Returns
  /// A `Map<String, dynamic>` with all quiz result properties.
  ///
  /// ## Example
  /// ```dart
  /// final result = QuizResult(...);
  /// final json = result.toJson();
  /// // Save to shared preferences or send to server
  /// ```
  Map<String, dynamic> toJson() {
    return {
      'correctAnswersCount': correctAnswersCount,
      'totalQuestions': totalQuestions,
      'durationInSeconds': durationInSeconds,
      'subjectName': subjectName,
      'percentageCorrect': percentageCorrect,
      'incorrectAnswersCount': incorrectAnswersCount,
      'formattedDuration': formattedDuration,
    };
  }

  @override
  String toString() {
    return 'QuizResult('
        'subject: $subjectName, '
        'score: ${(percentageCorrect * 100).toStringAsFixed(1)}%, '
        'correct: $correctAnswersCount/$totalQuestions, '
        'time: $formattedDuration'
        ')';
  }
}
