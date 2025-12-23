import 'dart:math' as math;
import 'package:flutter/material.dart';

class CircleProgressPainter extends CustomPainter {
  final double percentageCorrect;
  final double percentageWrong;
  final Color correctColor;
  final Color wrongColor;
  final Color backgroundColor;
  final double strokeWidth;
  final double backgroundStrokeWidth;

  CircleProgressPainter({
    required this.percentageCorrect,
    required this.percentageWrong,
    this.correctColor = Colors.blue,
    this.wrongColor = Colors.yellow,
    this.backgroundColor = Colors.grey,
    this.strokeWidth = 20.0,
    this.backgroundStrokeWidth = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double angleCorrect = 2 * math.pi * percentageCorrect;
    final double angleWrong = 2 * math.pi * percentageWrong;

    final Paint correctPaint = Paint()
      ..color = correctColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint wrongPaint = Paint()
      ..color = wrongColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = backgroundStrokeWidth;

    // Draw background circle
    canvas.drawCircle(
      size.center(Offset.zero),
      size.width / 2,
      backgroundPaint,
    );

    // Draw correct segment
    if (percentageCorrect > 0) {
      canvas.drawArc(
        Rect.fromCircle(
          center: size.center(Offset.zero),
          radius: size.width / 2,
        ),
        -math.pi / 2,
        angleCorrect,
        false,
        correctPaint,
      );
    }

    // Draw wrong segment
    if (percentageWrong > 0) {
      canvas.drawArc(
        Rect.fromCircle(
          center: size.center(Offset.zero),
          radius: size.width / 2,
        ),
        -math.pi / 2 + angleCorrect,
        angleWrong,
        false,
        wrongPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}