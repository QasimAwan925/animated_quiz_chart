import 'package:flutter/animation.dart';

class ChartAnimations {
  static Animation<double> createCorrectAnimation(
      AnimationController controller,
      double percentageCorrect,
      ) {
    return Tween<double>(begin: 0, end: percentageCorrect).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  static Animation<double> createWrongAnimation(
      AnimationController controller,
      double percentageWrong,
      ) {
    return Tween<double>(begin: 0, end: percentageWrong).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }
}