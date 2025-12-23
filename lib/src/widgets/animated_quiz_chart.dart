import 'package:flutter/material.dart';
import '../animations/chart_animations.dart';
import 'circle_progress_painter.dart';

/// An animated circular chart widget for visualizing quiz results.
///
/// This widget displays quiz scores as an animated donut/pie chart with
/// two segments: correct answers (blue by default) and wrong answers
/// (yellow by default). The chart animates from empty to full over a
/// customizable duration.
///
/// ## Usage
/// ```dart
/// AnimatedQuizChart(
///   correctAnswersCount: 7,
///   totalQuestions: 10,
///   size: 200,
///   animationDuration: Duration(seconds: 2),
///   correctColor: Colors.green,
///   wrongColor: Colors.red,
///   backgroundColor: Colors.grey[200],
///   showPercentage: true,
/// )
/// ```
///
/// ## Key Features
/// - Smooth animation from 0% to final percentage
/// - Customizable colors, sizes, and animation duration
/// - Optional percentage display in the center
/// - Responsive design that works on all screen sizes
class AnimatedQuizChart extends StatefulWidget {
  /// The number of correct answers in the quiz.
  ///
  /// This value must be between 0 and [totalQuestions].
  /// Used to calculate the percentage of correct answers.
  final int correctAnswersCount;

  /// The total number of questions in the quiz.
  ///
  /// Must be greater than 0. Used with [correctAnswersCount] to calculate
  /// the percentage score.
  final int totalQuestions;

  /// The duration of the chart animation.
  ///
  /// Controls how long it takes for the chart to animate from empty to full.
  /// Defaults to 3 seconds.
  final Duration animationDuration;

  /// The diameter of the circular chart in logical pixels.
  ///
  /// The chart will be drawn within a square of this size.
  /// Defaults to 180 pixels.
  final double size;

  /// The color used for the correct answers segment of the chart.
  ///
  /// This color fills the portion representing correct answers.
  /// Defaults to [Colors.blue].
  final Color correctColor;

  /// The color used for the wrong/incorrect answers segment of the chart.
  ///
  /// This color fills the portion representing incorrect answers.
  /// Defaults to [Colors.yellow].
  final Color wrongColor;

  /// The background color of the chart track.
  ///
  /// This color appears behind the animated segments.
  /// Defaults to [Colors.grey].
  final Color backgroundColor;

  /// The text style for the percentage display in the center.
  ///
  /// If null, a default style (fontSize: 24, fontWeight: w600) is used.
  /// Only used when [showPercentage] is true.
  final TextStyle? percentageTextStyle;

  /// Whether to display the percentage text in the center of the chart.
  ///
  /// When true, shows the percentage of correct answers as text.
  /// When false, the chart displays without text.
  /// Defaults to true.
  final bool showPercentage;

  /// Creates an [AnimatedQuizChart] widget.
  ///
  /// The [correctAnswersCount] and [totalQuestions] parameters are required.
  /// All other parameters have sensible defaults.
  ///
  /// Example:
  /// ```dart
  /// AnimatedQuizChart(
  ///   correctAnswersCount: 8,
  ///   totalQuestions: 10,
  ///   size: 200,
  ///   animationDuration: Duration(seconds: 2),
  /// )
  /// ```
  const AnimatedQuizChart({
    Key? key,
    required this.correctAnswersCount,
    required this.totalQuestions,
    this.animationDuration = const Duration(seconds: 3),
    this.size = 180,
    this.correctColor = Colors.blue,
    this.wrongColor = Colors.yellow,
    this.backgroundColor = Colors.grey,
    this.percentageTextStyle,
    this.showPercentage = true,
  }) : super(key: key);

  @override
  AnimatedQuizChartState createState() => AnimatedQuizChartState();
}

class AnimatedQuizChartState extends State<AnimatedQuizChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animationCorrect;
  late Animation<double> _animationWrong;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    final double percentageCorrect = widget.totalQuestions > 0
        ? widget.correctAnswersCount / widget.totalQuestions
        : 0;
    final double percentageWrong = 1 - percentageCorrect;

    _animationCorrect = ChartAnimations.createCorrectAnimation(
      _controller,
      percentageCorrect,
    );

    _animationWrong = ChartAnimations.createWrongAnimation(
      _controller,
      percentageWrong,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: CustomPaint(
                painter: CircleProgressPainter(
                  percentageCorrect: _animationCorrect.value,
                  percentageWrong: _animationWrong.value,
                  correctColor: widget.correctColor,
                  wrongColor: widget.wrongColor,
                  backgroundColor: widget.backgroundColor,
                ),
              ),
            ),
            if (widget.showPercentage)
              Container(
                width: widget.size * 0.75,
                height: widget.size * 0.75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.backgroundColor.withAlpha(51),
                ),
                child: Center(
                  child: Text(
                    "${(_animationCorrect.value * 100).toStringAsFixed(0)}%",
                    style: widget.percentageTextStyle ??
                        const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}