import 'package:flutter/material.dart';
import 'dart:ui';
import 'LevelPage.dart';
import 'Level1QuestionPage.dart';

final List<String> questions = [
  'Question 1: What programming language is used in Flutter?',
  'Question 2: ...',
  'Question 3: ...',
  'Question 4: ...',
  'Question 5: ...',
  'Question 6: ...',
  'Question 7: ...',
  'Question 8: ...',
  'Question 9: ...',
  'Question 10: ...',
  'Question 11: ...',
  'Question 12: ...',
  'Question 13: ...',
  'Question 14: ...',
  'Question 15: ...',
  'Question 16: ...',
  'Question 17: ...',
  'Question 18: ...',
  'Question 19: ...',
  'Question 20: ...',
  'Question 21: ...',
  'Question 22: ...',
  'Question 23: ...',
  'Question 24: ...',
  'Question 25: ...',
  'Question 26: ...',
  'Question 27: ...',
  'Question 28: ...',
  'Question 29: ...',
  'Question 30: ...',
  'Question 31: ...',
  'Question 32: ...',
  'Question 33: ...',
  'Question 34: ...',
  'Question 35: ...',
  'Question 36: ...',
  'Question 37: ...',
  'Question 38: ...',
  'Question 39: ...',
  'Question 40: ...',
  'Question 41: ...',
  'Question 42: ...',
  'Question 43: ...',
  'Question 44: ...',
  'Question 45: ...',
  'Question 46: ...',
  'Question 47: ...',
  'Question 48: ...',
  'Question 49: ...',
  'Question 50: ...',
];

class LevelSelectPage extends StatelessWidget {
  const LevelSelectPage({super.key});

  Color _getLevelColor(int level) {
    if (level <= 10) return Colors.greenAccent.shade400;
    if (level <= 20) return Colors.yellow.shade600;
    if (level <= 30) return Colors.orangeAccent.shade200;
    if (level <= 40) return Colors.pinkAccent.shade100;
    return Colors.redAccent.shade200;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF23242a),
                    Color(0xFF3a5ba0),
                    Color(0xFF23242a),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                color: Colors.black.withOpacity(0.35),
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                expandedHeight: 100,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 12, top: 8),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    'Select Level',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.9),
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black.withOpacity(0.7),
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  titlePadding: const EdgeInsets.only(bottom: 8),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(8),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.8,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final level = index + 1;
                      return Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(18),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: _getLevelColor(level),
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Colors.white.withOpacity(0.3), width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            if (level == 1) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level1QuestionPage()),
                              );
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => LevelPage(
                                    level: level,
                                    question: questions.length >= level
                                        ? questions[level - 1]
                                        : 'Вопрос для уровня $level ещё не добавлен.',
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text('Level $level', textAlign: TextAlign.center),
                        ),
                      );
                    },
                    childCount: 50,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}