import 'package:flutter/material.dart';
import '../models/quiz_result.dart';
import 'animated_quiz_chart.dart';

class ResultPage extends StatelessWidget {
  final QuizResult quizResult;
  final VoidCallback onViewAnswers;
  final Widget Function(BuildContext, QuizResult)? headerBuilder;
  final Widget Function(BuildContext, QuizResult)? footerBuilder;
  final Color correctColor;
  final Color wrongColor;
  final Color backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final EdgeInsetsGeometry padding;

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
                if (headerBuilder != null) headerBuilder!(context, quizResult),

                const SizedBox(height: 45),

                AnimatedQuizChart(
                  correctAnswersCount: quizResult.correctAnswersCount,
                  totalQuestions: quizResult.totalQuestions,
                  correctColor: correctColor,
                  wrongColor: wrongColor,
                  backgroundColor: Colors.grey.shade300,
                  size: 180,
                ),

                const SizedBox(height: 45),

                // Legend
                _buildLegend(context),

                const SizedBox(height: 25),

                // Stats Card
                _buildStatsCard(context),

                const SizedBox(height: 80),

                // View Answers Button
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

                if (footerBuilder != null) footerBuilder!(context, quizResult),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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

  Widget _buildStatsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
}