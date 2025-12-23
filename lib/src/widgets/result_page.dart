import 'package:flutter/material.dart';
import '../models/quiz_result.dart';
import 'animated_quiz_chart.dart';

/// A complete, pre-styled result page for displaying quiz results with visualizations.
///
/// This widget provides a full-screen layout that includes:
/// - An animated chart showing correct vs incorrect answers
/// - Detailed statistics in a card format
/// - A color-coded legend
/// - Action buttons for navigation
/// - Customizable header and footer sections
///
/// ## Features
/// - 🎨 Fully customizable colors, typography, and spacing
/// - 📱 Responsive design that works on all screen sizes
/// - 🔧 Extensible with custom header/footer builders
/// - 🎯 Professional UI with shadows, spacing, and visual hierarchy
/// - ⚡ Integrates seamlessly with [AnimatedQuizChart] and [QuizResult]
///
/// ## Usage
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => ResultPage(
///       quizResult: QuizResult(
///         correctAnswersCount: 8,
///         totalQuestions: 10,
///         durationInSeconds: 120,
///         subjectName: 'Mathematics',
///       ),
///       onViewAnswers: () {
///         // Navigate to answers screen
///         Navigator.push(context, MaterialPageRoute(
///           builder: (context) => AnswersScreen(),
///         ));
///       },
///       correctColor: Colors.green,
///       wrongColor: Colors.red,
///       backgroundColor: Colors.grey[50]!,
///     ),
///   ),
/// );
/// ```
///
/// ## Customization Examples
/// ```dart
/// // With custom header
/// ResultPage(
///   quizResult: result,
///   onViewAnswers: onViewAnswers,
///   headerBuilder: (context, result) => Container(
///     padding: EdgeInsets.all(16),
///     child: Text(
///       'Quiz Complete!',
///       style: Theme.of(context).textTheme.headlineSmall,
///     ),
///   ),
/// )
/// ```
class ResultPage extends StatelessWidget {
  /// The quiz result data to display on this page.
  ///
  /// Contains all necessary information: scores, timing, and subject.
  /// Required for the page to function properly.
  ///
  /// Example:
  /// ```dart
  /// quizResult: QuizResult(
  ///   correctAnswersCount: 7,
  ///   totalQuestions: 10,
  ///   durationInSeconds: 180,
  ///   subjectName: 'Science',
  /// )
  /// ```
  final QuizResult quizResult;

  /// Callback function invoked when the user taps the "See the answers" button.
  ///
  /// Typically used to navigate to a detailed answers review screen.
  /// Required to provide user interaction.
  ///
  /// Example:
  /// ```dart
  /// onViewAnswers: () {
  ///   Navigator.push(
  ///     context,
  ///     MaterialPageRoute(builder: (context) => AnswersScreen()),
  ///   );
  /// }
  /// ```
  final VoidCallback onViewAnswers;

  /// Optional builder for creating a custom header above the chart.
  ///
  /// Use this to add custom content like titles, badges, or additional
  /// information specific to your app.
  ///
  /// Example:
  /// ```dart
  /// headerBuilder: (context, result) => Column(
  ///   children: [
  ///     Text('Congratulations!', style: TextStyle(fontSize: 24)),
  ///     Text('You scored ${result.percentageCorrect * 100}%'),
  ///   ],
  /// )
  /// ```
  final Widget Function(BuildContext, QuizResult)? headerBuilder;

  /// Optional builder for creating a custom footer below the main content.
  ///
  /// Use this to add additional actions, links, or information below the
  /// primary result content.
  ///
  /// Example:
  /// ```dart
  /// footerBuilder: (context, result) => Row(
  ///   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  ///   children: [
  ///     TextButton(onPressed: shareResults, child: Text('Share')),
  ///     TextButton(onPressed: retryQuiz, child: Text('Retry')),
  ///   ],
  /// )
  /// ```
  final Widget Function(BuildContext, QuizResult)? footerBuilder;

  /// The color used for correct answers in the chart and legend.
  ///
  /// Should contrast well with [wrongColor] and [backgroundColor].
  /// Defaults to [Colors.blue].
  ///
  /// Example: `Colors.green` for positive results
  final Color correctColor;

  /// The color used for incorrect answers in the chart and legend.
  ///
  /// Should contrast well with [correctColor] and [backgroundColor].
  /// Defaults to [Colors.yellow].
  ///
  /// Example: `Colors.red` for incorrect answers
  final Color wrongColor;

  /// The background color of the entire page.
  ///
  /// Sets the Scaffold's background color.
  /// Defaults to [Colors.white].
  ///
  /// Example: `Theme.of(context).scaffoldBackgroundColor` for theme consistency
  final Color backgroundColor;

  /// The text style used for titles and labels throughout the page.
  ///
  /// Applied to legend labels, stat card titles, and other descriptive text.
  /// If null, defaults to a standard style (fontSize: 14-16, weight: 400-600).
  ///
  /// Example:
  /// ```dart
  /// titleStyle: TextStyle(
  ///   fontSize: 16,
  ///   fontWeight: FontWeight.w500,
  ///   color: Colors.grey[800],
  /// )
  /// ```
  final TextStyle? titleStyle;

  /// The text style used for values and numbers throughout the page.
  ///
  /// Applied to stat card values and other numerical data.
  /// If null, defaults to a bold version of the title style.
  ///
  /// Example:
  /// ```dart
  /// valueStyle: TextStyle(
  ///   fontSize: 18,
  ///   fontWeight: FontWeight.w700,
  ///   color: Colors.blue,
  /// )
  /// ```
  final TextStyle? valueStyle;

  /// The horizontal padding applied to the main content.
  ///
  /// Controls how far content is inset from screen edges.
  /// Defaults to 20 pixels on left and right.
  ///
  /// Example: `EdgeInsets.all(16)` for uniform padding
  final EdgeInsetsGeometry padding;

  /// Creates a [ResultPage] widget for displaying quiz results.
  ///
  /// ## Required Parameters
  /// - [quizResult]: The quiz data to display
  /// - [onViewAnswers]: Callback for the action button
  ///
  /// ## Optional Parameters
  /// All other parameters have sensible defaults but can be customized
  /// to match your app's design system.
  ///
  /// ## Example
  /// ```dart
  /// ResultPage(
  ///   quizResult: myQuizResult,
  ///   onViewAnswers: () => navigateToAnswers(),
  ///   correctColor: Colors.greenAccent,
  ///   wrongColor: Colors.redAccent,
  ///   backgroundColor: Colors.grey[50]!,
  ///   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  /// )
  /// ```
  const ResultPage({
    Key? key,
    required this.quizResult,
    required this.onViewAnswers,
    this.headerBuilder,
    this.footerBuilder,
    this.correctColor = Colors.blue,
    this.wrongColor = Colors.yellow,
    this.backgroundColor = Colors.white,
    this.titleStyle,
    this.valueStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: padding,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Custom Header (if provided)
                if (headerBuilder != null) headerBuilder!(context, quizResult),

                const SizedBox(height: 45),

                // Main Chart Visualization
                AnimatedQuizChart(
                  correctAnswersCount: quizResult.correctAnswersCount,
                  totalQuestions: quizResult.totalQuestions,
                  correctColor: correctColor,
                  wrongColor: wrongColor,
                  backgroundColor: Colors.grey.shade300,
                  size: 180,
                ),

                const SizedBox(height: 45),

                // Color Legend
                _buildLegend(context),

                const SizedBox(height: 25),

                // Statistics Card
                _buildStatsCard(context),

                const SizedBox(height: 80),

                // Primary Action Button
                ElevatedButton(
                  onPressed: onViewAnswers,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('See the answers'),
                ),

                const SizedBox(height: 25),

                // Custom Footer (if provided)
                if (footerBuilder != null) footerBuilder!(context, quizResult),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the color legend showing correct vs incorrect colors.
  ///
  /// Creates a horizontal row with colored dots and labels explaining
  /// the chart's color scheme. Uses [correctColor] and [wrongColor].
  Widget _buildLegend(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Correct Answer Indicator
        CircleAvatar(backgroundColor: correctColor, radius: 4.5),
        const SizedBox(width: 10),
        Text(
          'Correct',
          style: titleStyle ??
              const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black,
              ),
        ),
        const SizedBox(width: 20),
        // Wrong Answer Indicator
        CircleAvatar(backgroundColor: wrongColor, radius: 4.5),
        const SizedBox(width: 10),
        Text(
          'Incorrect',
          style: titleStyle ??
              const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black,
              ),
        ),
      ],
    );
  }

  /// Builds the statistics card with detailed quiz metrics.
  ///
  /// Displays key information in a styled card with shadow:
  /// - Total questions
  /// - Correct answers count
  /// - Incorrect answers count
  /// - Completion time
  Widget _buildStatsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStatRow('Total Questions', '${quizResult.totalQuestions}'),
          const SizedBox(height: 10),
          _buildStatRow('Correct', '${quizResult.correctAnswersCount}'),
          const SizedBox(height: 10),
          _buildStatRow('Incorrect', '${quizResult.incorrectAnswersCount}'),
          const SizedBox(height: 10),
          _buildStatRow('Time', '${quizResult.durationInSeconds} seconds'),
        ],
      ),
    );
  }

  /// Builds a single row for the statistics card.
  ///
  /// Creates a horizontal layout with a title on the left and value on the right.
  /// Uses [titleStyle] for the title and [valueStyle] for the value.
  Widget _buildStatRow(String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: titleStyle ??
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
        ),
        const Spacer(),
        Text(
          value,
          style: valueStyle ??
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
        ),
      ],
    );
  }

  /// Creates a copy of this [ResultPage] with updated properties.
  ///
  /// Useful for creating variations of the result page with different
  /// styling or behavior while maintaining the same quiz data.
  ///
  /// Example:
  /// ```dart
  /// final basePage = ResultPage(...);
  /// final darkModePage = basePage.copyWith(
  ///   backgroundColor: Colors.grey[900]!,
  ///   correctColor: Colors.greenAccent,
  ///   titleStyle: TextStyle(color: Colors.white),
  /// );
  /// ```
  ResultPage copyWith({
    QuizResult? quizResult,
    VoidCallback? onViewAnswers,
    Widget Function(BuildContext, QuizResult)? headerBuilder,
    Widget Function(BuildContext, QuizResult)? footerBuilder,
    Color? correctColor,
    Color? wrongColor,
    Color? backgroundColor,
    TextStyle? titleStyle,
    TextStyle? valueStyle,
    EdgeInsetsGeometry? padding,
  }) {
    return ResultPage(
      quizResult: quizResult ?? this.quizResult,
      onViewAnswers: onViewAnswers ?? this.onViewAnswers,
      headerBuilder: headerBuilder ?? this.headerBuilder,
      footerBuilder: footerBuilder ?? this.footerBuilder,
      correctColor: correctColor ?? this.correctColor,
      wrongColor: wrongColor ?? this.wrongColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleStyle: titleStyle ?? this.titleStyle,
      valueStyle: valueStyle ?? this.valueStyle,
      padding: padding ?? this.padding,
    );
  }
}