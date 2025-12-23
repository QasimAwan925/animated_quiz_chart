import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A custom painter that draws an animated circular progress chart for quiz results.
///
/// This painter creates a donut/pie chart with two segments:
/// - Correct answers (typically blue)
/// - Wrong answers (typically yellow)
///
/// The chart is designed to work with [AnimatedQuizChart] widget and animates
/// smoothly between states. It handles the visual representation of quiz scores
/// with customizable colors, stroke widths, and segment sizes.
///
/// ## Visual Structure
/// ```
///          ┌─────────────────────────┐
///          │        Background       │
///          │  ┌─────────────────┐   │
///          │  │   Wrong         │   │
///          │  │   Segment       │   │
///          │  │   ┌─────────┐   │   │
///          │  │   │  Text   │   │   │
///          │  │   │  Area   │   │   │
///          │  │   └─────────┘   │   │
///          │  │   Correct        │   │
///          │  │   Segment        │   │
///          │  └─────────────────┘   │
///          └─────────────────────────┘
/// ```
///
/// ## Usage
/// ```dart
/// CustomPaint(
///   painter: CircleProgressPainter(
///     percentageCorrect: 0.7,
///     percentageWrong: 0.3,
///     correctColor: Colors.green,
///     wrongColor: Colors.red,
///     backgroundColor: Colors.grey[300]!,
///     strokeWidth: 25.0,
///     backgroundStrokeWidth: 8.0,
///   ),
///   size: Size(200, 200),
/// )
/// ```
class CircleProgressPainter extends CustomPainter {
  /// The proportion of correct answers, expressed as a decimal between 0.0 and 1.0.
  ///
  /// Represents the portion of the circle to fill with [correctColor].
  /// Typically calculated as `correctAnswersCount / totalQuestions`.
  /// Must be between 0.0 and 1.0 inclusive.
  ///
  /// Example: 0.75 means 75% of the circle will be the correct segment.
  final double percentageCorrect;

  /// The proportion of wrong answers, expressed as a decimal between 0.0 and 1.0.
  ///
  /// Represents the portion of the circle to fill with [wrongColor].
  /// Typically calculated as `1 - percentageCorrect`.
  /// Must be between 0.0 and 1.0 inclusive.
  ///
  /// Note: For a complete circle, [percentageCorrect] + [percentageWrong] should equal 1.0.
  final double percentageWrong;

  /// The color for the segment representing correct answers.
  ///
  /// This color fills the arc from 0 radians to `2π * percentageCorrect`.
  /// Defaults to [Colors.blue].
  ///
  /// Example: Use [Colors.green] for positive results or [Colors.blueAccent] for branding.
  final Color correctColor;

  /// The color for the segment representing wrong/incorrect answers.
  ///
  /// This color fills the arc after the correct segment, from
  /// `2π * percentageCorrect` to `2π * (percentageCorrect + percentageWrong)`.
  /// Defaults to [Colors.yellow].
  ///
  /// Example: Use [Colors.red] for negative results or [Colors.orange] for warnings.
  final Color wrongColor;

  /// The color for the background circle/track behind the progress segments.
  ///
  /// This is drawn as a full circle behind the progress arcs to provide
  /// visual context and contrast. Defaults to [Colors.grey].
  ///
  /// Example: Use [Colors.grey[200]] for a light theme or [Colors.grey[800]] for dark.
  final Color backgroundColor;

  /// The width of the progress segments (correct and wrong) in logical pixels.
  ///
  /// Controls the thickness of the colored arcs representing quiz scores.
  /// Larger values create thicker, more prominent segments.
  /// Defaults to 20.0 pixels.
  ///
  /// Example: Use 15.0 for subtle charts or 30.0 for bold visualizations.
  final double strokeWidth;

  /// The width of the background circle/track in logical pixels.
  ///
  /// Controls the thickness of the background ring behind the progress segments.
  /// Typically smaller than [strokeWidth] to create visual hierarchy.
  /// Defaults to 4.0 pixels.
  ///
  /// Example: Use 2.0 for minimal background or 8.0 for pronounced track.
  final double backgroundStrokeWidth;

  /// Creates a [CircleProgressPainter] with the specified visual properties.
  ///
  /// ## Parameters
  /// - [percentageCorrect]: Required. Portion of correct answers (0.0 to 1.0)
  /// - [percentageWrong]: Required. Portion of wrong answers (0.0 to 1.0)
  /// - [correctColor]: Optional. Color for correct segment (default: [Colors.blue])
  /// - [wrongColor]: Optional. Color for wrong segment (default: [Colors.yellow])
  /// - [backgroundColor]: Optional. Background circle color (default: [Colors.grey])
  /// - [strokeWidth]: Optional. Progress segment thickness (default: 20.0)
  /// - [backgroundStrokeWidth]: Optional. Background thickness (default: 4.0)
  ///
  /// ## Validation
  /// The painter will clip percentages to valid ranges (0.0 to 1.0) and ensure
  /// the total doesn't exceed 100% of the circle.
  ///
  /// ## Example
  /// ```dart
  /// CircleProgressPainter(
  ///   percentageCorrect: 0.8, // 80% correct
  ///   percentageWrong: 0.2,   // 20% wrong
  ///   correctColor: Colors.greenAccent,
  ///   wrongColor: Colors.redAccent,
  ///   strokeWidth: 25.0,
  /// )
  /// ```
  CircleProgressPainter({
    required this.percentageCorrect,
    required this.percentageWrong,
    this.correctColor = Colors.blue,
    this.wrongColor = Colors.yellow,
    this.backgroundColor = Colors.grey,
    this.strokeWidth = 20.0,
    this.backgroundStrokeWidth = 4.0,
  }) {
    // Validate and normalize input values
    assert(percentageCorrect >= 0.0 && percentageCorrect <= 1.0,
    'percentageCorrect must be between 0.0 and 1.0, got $percentageCorrect');
    assert(percentageWrong >= 0.0 && percentageWrong <= 1.0,
    'percentageWrong must be between 0.0 and 1.0, got $percentageWrong');
    assert(strokeWidth > 0, 'strokeWidth must be positive, got $strokeWidth');
    assert(backgroundStrokeWidth > 0,
    'backgroundStrokeWidth must be positive, got $backgroundStrokeWidth');
  }

  /// Paints the circular progress chart on the canvas.
  ///
  /// This method implements the painting logic for the chart:
  /// 1. Draws the background circle
  /// 2. Draws the correct answers segment (starting at 12 o'clock)
  /// 3. Draws the wrong answers segment (immediately after correct segment)
  ///
  /// The chart starts at the top (-π/2 radians) and progresses clockwise.
  ///
  /// ## Parameters
  /// - [canvas]: The canvas to draw on
  /// - [size]: The dimensions of the painting area
  ///
  /// ## Coordinate System
  /// - Center: `size.center(Offset.zero)`
  /// - Radius: `size.width / 2`
  /// - Angles: Measured in radians, 0 radians = 3 o'clock, increasing clockwise
  @override
  void paint(Canvas canvas, Size size) {
    // Ensure percentages are valid and don't exceed 100%
    final normalizedCorrect = percentageCorrect.clamp(0.0, 1.0);
    final normalizedWrong = (percentageWrong + percentageCorrect > 1.0)
        ? 1.0 - normalizedCorrect
        : percentageWrong.clamp(0.0, 1.0 - normalizedCorrect);

    // Convert percentages to angles in radians
    final double angleCorrect = 2 * math.pi * normalizedCorrect;
    final double angleWrong = 2 * math.pi * normalizedWrong;

    // Create paint for correct segment
    final Paint correctPaint = Paint()
      ..color = correctColor
      ..strokeCap = StrokeCap.round // Rounded ends for smoother segments
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Create paint for wrong segment
    final Paint wrongPaint = Paint()
      ..color = wrongColor
      ..strokeCap = StrokeCap.round // Rounded ends for smoother segments
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Create paint for background circle
    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = backgroundStrokeWidth;

    final Offset center = size.center(Offset.zero);
    final double radius = size.width / 2;

    // Draw the background circle (full 360°)
    canvas.drawCircle(center, radius, backgroundPaint);

    // Starting angle: 12 o'clock position (-π/2 radians)
    const double startAngle = -math.pi / 2;

    // Draw correct segment if there are correct answers
    if (normalizedCorrect > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        angleCorrect,
        false, // Not filled (stroke only)
        correctPaint,
      );
    }

    // Draw wrong segment if there are wrong answers
    if (normalizedWrong > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + angleCorrect, // Start after correct segment
        angleWrong,
        false, // Not filled (stroke only)
        wrongPaint,
      );
    }

    // Optional: Draw a subtle shadow/glow effect
    if (strokeWidth > 15.0) {
      final Paint shadowPaint = Paint()
        ..color = Colors.black.withAlpha(26)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      if (normalizedCorrect > 0) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          angleCorrect,
          false,
          shadowPaint,
        );
      }
    }
  }

  /// Determines whether this painter needs to repaint.
  ///
  /// Returns true to always repaint when properties change.
  /// For optimization in more complex scenarios, you could implement
  /// comparison logic with [oldDelegate].
  ///
  /// ## Parameters
  /// - [oldDelegate]: The previous instance of the painter
  ///
  /// ## Returns
  /// `true` if repainting is needed, `false` to reuse the previous paint
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is! CircleProgressPainter) return true;

    // Only repaint if properties have actually changed
    return oldDelegate.percentageCorrect != percentageCorrect ||
        oldDelegate.percentageWrong != percentageWrong ||
        oldDelegate.correctColor != correctColor ||
        oldDelegate.wrongColor != wrongColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.backgroundStrokeWidth != backgroundStrokeWidth;
  }

  /// Creates a copy of this painter with modified properties.
  ///
  /// Useful for creating variations of the same painter with different
  /// colors, widths, or percentages while maintaining other settings.
  ///
  /// ## Example
  /// ```dart
  /// final basePainter = CircleProgressPainter(
  ///   percentageCorrect: 0.5,
  ///   percentageWrong: 0.5,
  ///   correctColor: Colors.blue,
  /// );
  ///
  /// final highlightedPainter = basePainter.copyWith(
  ///   correctColor: Colors.green,
  ///   strokeWidth: 30.0,
  /// );
  /// ```
  CircleProgressPainter copyWith({
    double? percentageCorrect,
    double? percentageWrong,
    Color? correctColor,
    Color? wrongColor,
    Color? backgroundColor,
    double? strokeWidth,
    double? backgroundStrokeWidth,
  }) {
    return CircleProgressPainter(
      percentageCorrect: percentageCorrect ?? this.percentageCorrect,
      percentageWrong: percentageWrong ?? this.percentageWrong,
      correctColor: correctColor ?? this.correctColor,
      wrongColor: wrongColor ?? this.wrongColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      backgroundStrokeWidth: backgroundStrokeWidth ?? this.backgroundStrokeWidth,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CircleProgressPainter &&
              runtimeType == other.runtimeType &&
              percentageCorrect == other.percentageCorrect &&
              percentageWrong == other.percentageWrong &&
              correctColor == other.correctColor &&
              wrongColor == other.wrongColor &&
              backgroundColor == other.backgroundColor &&
              strokeWidth == other.strokeWidth &&
              backgroundStrokeWidth == other.backgroundStrokeWidth;

  @override
  int get hashCode =>
      percentageCorrect.hashCode ^
      percentageWrong.hashCode ^
      correctColor.hashCode ^
      wrongColor.hashCode ^
      backgroundColor.hashCode ^
      strokeWidth.hashCode ^
      backgroundStrokeWidth.hashCode;
}