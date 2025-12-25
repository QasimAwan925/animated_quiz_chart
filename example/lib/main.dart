import 'package:flutter/material.dart';
import 'package:animated_quiz_chart/animated_quiz_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Quiz Chart Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SimpleDemoPage(),
    );
  }
}

class SimpleDemoPage extends StatefulWidget {
  const SimpleDemoPage({super.key});

  @override
  State<SimpleDemoPage> createState() => _SimpleDemoPageState();
}

class _SimpleDemoPageState extends State<SimpleDemoPage> {
  int correctAnswers = 7;
  int totalQuestions = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Quiz Chart Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Chart Display
              AnimatedQuizChart(
                correctAnswersCount: correctAnswers,
                totalQuestions: totalQuestions,
                size: 200,
                correctColor: Colors.green,
                wrongColor: Colors.red,
              ),

              const SizedBox(height: 40),

              // Controls
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('Adjust Values:'),
                      const SizedBox(height: 16),

                      // Correct Answers Slider
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Correct Answers: $correctAnswers'),
                          Slider(
                            value: correctAnswers.toDouble(),
                            min: 0,
                            max: totalQuestions.toDouble(),
                            divisions: totalQuestions,
                            onChanged: (value) {
                              setState(() {
                                correctAnswers = value.toInt();
                              });
                            },
                          ),
                        ],
                      ),

                      // Total Questions Slider
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Questions: $totalQuestions'),
                          Slider(
                            value: totalQuestions.toDouble(),
                            min: 1,
                            max: 20,
                            divisions: 19,
                            onChanged: (value) {
                              setState(() {
                                totalQuestions = value.toInt();
                                if (correctAnswers > totalQuestions) {
                                  correctAnswers = totalQuestions;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Full Page Example Button
              ElevatedButton(
                onPressed: () {
                  final quizResult = QuizResult(
                    correctAnswersCount: correctAnswers,
                    totalQuestions: totalQuestions,
                    durationInSeconds: 150,
                    subjectName: 'Demo Quiz',
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: const Text('Quiz Results'),
                          leading: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        body: ResultPage(
                          quizResult: quizResult,
                          onViewAnswers: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Viewing answers...'),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Text('Open Full Result Page'),
                ),
              ),

              // Stats Display
              const SizedBox(height: 30),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('Current Stats:'),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Percentage:'),
                          Text(
                              '${((correctAnswers / totalQuestions) * 100).toStringAsFixed(1)}%'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Correct/Total:'),
                          Text('$correctAnswers / $totalQuestions'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Incorrect:'),
                          Text('${totalQuestions - correctAnswers}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
