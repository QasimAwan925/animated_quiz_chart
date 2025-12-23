import 'package:flutter/animation.dart';

/// Provides animation utilities for creating smooth chart animations.
///
/// This class contains static methods that create [Animation] objects
/// specifically designed for animating quiz chart segments (correct and
/// wrong answers). The animations use easing curves for natural-looking
/// motion.
///
/// ## Usage
/// Typically used with an [AnimationController] to create animated
/// transitions for chart segments.
///
/// ```dart
/// // Create animations for a quiz with 70% correct answers
/// final animationController = AnimationController(
///   vsync: this,
///   duration: Duration(seconds: 2),
/// );
///
/// final correctAnimation = ChartAnimations.createCorrectAnimation(
///   animationController,
///   0.7, // 70% correct
/// );
///
/// final wrongAnimation = ChartAnimations.createWrongAnimation(
///   animationController,
///   0.3, // 30% wrong
/// );
///
/// // Start the animation
/// animationController.forward();
/// ```
class ChartAnimations {
  /// Creates an animation for the correct answers segment of a quiz chart.
  ///
  /// This animation smoothly transitions from 0 to the target percentage
  /// of correct answers using an ease-in-out curve for natural motion.
  ///
  /// ## Parameters
  /// - [controller]: The [AnimationController] that drives the animation.
  ///   Must be properly initialized with a duration and vsync.
  /// - [percentageCorrect]: The target percentage of correct answers,
  ///   represented as a value between 0.0 and 1.0 (e.g., 0.75 for 75%).
  ///
  /// ## Returns
  /// An [Animation<double>] that goes from 0.0 to [percentageCorrect]
  /// over the controller's duration.
  ///
  /// ## Example
  /// ```dart
  /// final animation = ChartAnimations.createCorrectAnimation(
  ///   myController,
  ///   0.8, // Animate to 80% correct
  /// );
  /// ```
  static Animation<double> createCorrectAnimation(
      AnimationController controller,
      double percentageCorrect,
      ) {
    return Tween<double>(begin: 0, end: percentageCorrect).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  /// Creates an animation for the wrong answers segment of a quiz chart.
  ///
  /// This animation smoothly transitions from 0 to the target percentage
  /// of wrong answers using an ease-in-out curve. Typically used alongside
  /// [createCorrectAnimation] to animate both segments simultaneously.
  ///
  /// ## Parameters
  /// - [controller]: The [AnimationController] that drives the animation.
  ///   Must be properly initialized with a duration and vsync.
  /// - [percentageWrong]: The target percentage of wrong answers,
  ///   represented as a value between 0.0 and 1.0 (e.g., 0.25 for 25%).
  ///
  /// ## Returns
  /// An [Animation<double>] that goes from 0.0 to [percentageWrong]
  /// over the controller's duration.
  ///
  /// ## Example
  /// ```dart
  /// final animation = ChartAnimations.createWrongAnimation(
  ///   myController,
  ///   0.2, // Animate to 20% wrong
  /// );
  /// ```
  ///
  /// ## Note
  /// For a complete quiz visualization, the sum of [percentageCorrect]
  /// (from [createCorrectAnimation]) and [percentageWrong] should be 1.0.
  static Animation<double> createWrongAnimation(
      AnimationController controller,
      double percentageWrong,
      ) {
    return Tween<double>(begin: 0, end: percentageWrong).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }
}