/// A Flutter package for creating animated and interactive quiz result visualizations.
///
/// This package provides customizable animated charts and result pages for displaying
/// quiz scores, progress indicators, and performance metrics with smooth animations.
///
/// ## Features
/// - 🎯 **Animated circular progress charts** with customizable colors and sizes
/// - 📊 **Interactive result pages** for comprehensive score breakdowns
/// - ⚡ **Smooth animations** with configurable durations and curves
/// - 🎨 **Fully customizable** appearance and behavior
/// - 📱 **Responsive design** that works on all screen sizes
///
/// ## Getting Started
///
/// 1. Add the package to your `pubspec.yaml`:
/// ```yaml
/// dependencies:
///   animated_quiz_chart: ^1.0.0
/// ```
///
/// 2. Import the package in your Dart file:
/// ```dart
/// import 'package:animated_quiz_chart/animated_quiz_chart.dart';
/// ```
///
/// 3. Use the widgets in your app:
/// ```dart
/// // Simple progress chart
/// AnimatedQuizChart(
///   correctAnswersCount: 7,
///   totalQuestions: 10,
///   size: 200,
///   animationDuration: Duration(seconds: 2),
///   correctColor: Colors.green,
///   wrongColor: Colors.red,
/// )
///
/// // Complete result page
/// ResultPage(
///   quizResult: QuizResult(
///     correctAnswersCount: 8,
///     totalQuestions: 10,
///     durationInSeconds: 120,
///     subjectName: 'Mathematics',
///   ),
///   onViewAnswers: () {
///     // Navigate to answers screen
///     Navigator.push(context, MaterialPageRoute(
///       builder: (context) => AnswersScreen(),
///     ));
///   },
/// )
/// ```
///
/// ## Widgets
/// - [AnimatedQuizChart] - An animated circular progress chart showing correct vs incorrect answers
/// - [ResultPage] - A complete result page with chart, statistics, and action buttons
///
/// ## Models
/// - [QuizResult] - Represents quiz result data with scores, timing, and subject information
///
/// ## Example
/// Check the `example/` folder for a complete working example.
///
/// ## Issues and Feedback
/// Please file issues and feature requests on the [GitHub repository](https://github.com/QasimAwan925/animated_quiz_chart).
library animated_quiz_chart;

export 'src/widgets/animated_quiz_chart.dart';
export 'src/widgets/result_page.dart';
export 'src/models/quiz_result.dart';
export 'src/widgets/circle_progress_painter.dart';
