import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animated_quiz_chart/animated_quiz_chart.dart';

void main() {
  group('QuizResult Model Tests', () {
    test('QuizResult percentage calculation', () {
      final result = QuizResult(
        correctAnswersCount: 7,
        totalQuestions: 10,
        durationInSeconds: 120,
        subjectName: 'Math',
      );

      // Use closeTo for floating point comparison
      expect(result.percentageCorrect, closeTo(0.7, 0.0001));
      expect(result.percentageWrong, closeTo(0.3, 0.0001));
      expect(result.incorrectAnswersCount, 3);
    });

    test('QuizResult with zero questions', () {
      final result = QuizResult(
        correctAnswersCount: 0,
        totalQuestions: 0,
        durationInSeconds: 0,
        subjectName: 'Empty',
      );

      expect(result.percentageCorrect, 0);
      expect(result.percentageWrong, 1);
      expect(result.incorrectAnswersCount, 0);
    });
  });

  group('AnimatedQuizChart Widget Tests', () {
    testWidgets('AnimatedQuizChart renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedQuizChart(
              correctAnswersCount: 5,
              totalQuestions: 10,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 4)); // Wait for animation

      expect(find.byType(AnimatedQuizChart), findsOneWidget);
      // The chart shows percentage in the center - check for "50%"
      expect(find.text('50%'), findsOneWidget);
    });

    testWidgets('AnimatedQuizChart with custom colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedQuizChart(
              correctAnswersCount: 8,
              totalQuestions: 10,
              correctColor: Colors.green,
              wrongColor: Colors.red,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 4)); // Wait for animation

      expect(find.byType(AnimatedQuizChart), findsOneWidget);
      expect(find.text('80%'), findsOneWidget);
    });

    testWidgets('AnimatedQuizChart without percentage', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedQuizChart(
              correctAnswersCount: 3,
              totalQuestions: 10,
              showPercentage: false,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 4));

      expect(find.byType(AnimatedQuizChart), findsOneWidget);
      expect(find.text('30%'), findsNothing);
    });

    testWidgets('AnimatedQuizChart with zero questions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedQuizChart(
              correctAnswersCount: 0,
              totalQuestions: 0,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 4));

      expect(find.byType(AnimatedQuizChart), findsOneWidget);
      expect(find.text('0%'), findsOneWidget);
    });
  });

  group('ResultPage Widget Tests', () {
    testWidgets('ResultPage renders correctly', (WidgetTester tester) async {
      final quizResult = QuizResult(
        correctAnswersCount: 7,
        totalQuestions: 10,
        durationInSeconds: 120,
        subjectName: 'Test Subject',
      );

      bool viewAnswersCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ResultPage(
            quizResult: quizResult,
            onViewAnswers: () => viewAnswersCalled = true,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check for the chart
      expect(find.byType(AnimatedQuizChart), findsOneWidget);

      // Check for statistics labels
      expect(find.text('Total Questions'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('Correct'), findsNWidgets(2)); // In legend and stats
      expect(find.text('7'), findsOneWidget);
      expect(find.text('See the answers'), findsOneWidget);

      // Test button tap
      await tester.tap(find.text('See the answers'));
      expect(viewAnswersCalled, true);
    });

    testWidgets('ResultPage custom header', (WidgetTester tester) async {
      final quizResult = QuizResult(
        correctAnswersCount: 5,
        totalQuestions: 8,
        durationInSeconds: 90,
        subjectName: 'Custom Test',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ResultPage(
            quizResult: quizResult,
            onViewAnswers: () {},
            headerBuilder: (context, result) => Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue,
              child: Text('Custom Header: ${result.subjectName}'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Custom Header: Custom Test'), findsOneWidget);
      expect(find.byType(AnimatedQuizChart), findsOneWidget);
    });
  });

  group('Integration Tests', () {
    testWidgets('Complete flow test', (WidgetTester tester) async {
      // Create a mock app with navigation
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(
                          quizResult: QuizResult(
                            correctAnswersCount: 9,
                            totalQuestions: 12,
                            durationInSeconds: 180,
                            subjectName: 'Integration Test',
                          ),
                          onViewAnswers: () {},
                        ),
                      ),
                    );
                  },
                  child: const Text('Show Results'),
                ),
              ),
            ),
          ),
        ),
      );

      // Initial page
      expect(find.text('Show Results'), findsOneWidget);

      // Navigate to result page
      await tester.tap(find.text('Show Results'));
      await tester.pumpAndSettle(const Duration(seconds: 5)); // Wait for animation

      // Verify result page
      expect(find.text('75%'), findsOneWidget); // 9/12 = 75%
      expect(find.text('Total Questions'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('Correct'), findsNWidgets(2));
      expect(find.text('9'), findsOneWidget);
    });
  });
}