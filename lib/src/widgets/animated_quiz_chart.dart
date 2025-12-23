import 'package:flutter/material.dart';
import '../animations/chart_animations.dart';
import 'circle_progress_painter.dart';

class AnimatedQuizChart extends StatefulWidget {
  final int correctAnswersCount;
  final int totalQuestions;
  final Duration animationDuration;
  final double size;
  final Color correctColor;
  final Color wrongColor;
  final Color backgroundColor;
  final TextStyle? percentageTextStyle;
  final bool showPercentage;

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
  _AnimatedQuizChartState createState() => _AnimatedQuizChartState();
}

class _AnimatedQuizChartState extends State<AnimatedQuizChart>
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
                  color: widget.backgroundColor.withOpacity(0.2),
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