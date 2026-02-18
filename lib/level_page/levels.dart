
import 'dart:ui';
import 'package:flutter/material.dart';
import 'level_page.dart';
import '../all_levels/level1.dart';
import '../all_levels/level2.dart';
import '../all_levels/level3.dart';
import '../all_levels/level4.dart';
import '../all_levels/level5.dart';
import '../all_levels/level6.dart';
import '../all_levels/level7.dart';
import '../all_levels/level8.dart';
import '../all_levels/level9.dart';
import '../all_levels/level10.dart';
import '../all_levels/level11.dart';
import '../all_levels/level12.dart';
import '../all_levels/level13.dart';
import '../all_levels/level14.dart';
import '../all_levels/level15.dart';
import '../all_levels/level16.dart';
import '../all_levels/level17.dart';
import '../all_levels/level18.dart';
import '../all_levels/level19.dart';
import '../all_levels/level20.dart';
import '../all_levels/level21.dart';
import '../all_levels/level22.dart';
import '../all_levels/level23.dart';
import '../all_levels/level24.dart';
import '../all_levels/level25.dart';
import '../all_levels/level26.dart';
import '../all_levels/level27.dart';
import '../all_levels/level28.dart';
import '../all_levels/level29.dart';
import '../all_levels/level30.dart';

const List<String> questions = [];

final List<Widget> levelPages = [
  const Level1QuestionPage(),
  const Level2QuestionPage(),
  const Level3QuestionPage(),
  const Level4QuestionPage(),
  const Level5QuestionPage(),
  const Level6QuestionPage(),
  const Level7QuestionPage(),
  const Level8QuestionPage(),
  const Level9QuestionPage(),
  const Level10QuestionPage(),
  const Level11QuestionPage(),
  const Level12QuestionPage(),
  const Level13QuestionPage(),
  const Level14QuestionPage(),
  const Level15QuestionPage(),
  const Level16QuestionPage(),
  const Level17QuestionPage(),
  const Level18QuestionPage(),
  const Level19QuestionPage(),
  const Level20QuestionPage(),
  const Level21QuestionPage(),
  const Level22QuestionPage(),
  const Level23QuestionPage(),
  const Level24QuestionPage(),
  const Level25QuestionPage(),
  const Level26QuestionPage(),
  const Level27QuestionPage(),
  const Level28QuestionPage(),
  const Level29QuestionPage(),
  const Level30QuestionPage(),
];

class LevelSelectPage extends StatelessWidget {
  const LevelSelectPage({super.key});

  Color _getLevelColor(int level) {
    final t = (level - 1) / 29;
    final hsl = HSLColor.fromAHSL(1, 120 - 120 * t, 0.85, 0.6);
    return hsl.toColor();
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
                  colors: [Color(0xFF23242a), Color(0xFF3a5ba0), Color(0xFF23242a)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(color: Colors.black.withOpacity(0.35)),
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
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    'Select Level',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withValues(alpha: 0.9),
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black.withValues(alpha: 0.7),
                          offset: const Offset(2, 2),
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
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.3), width: 2),
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
                            } else if (level == 2) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level2QuestionPage()),
                              );
                            } else if (level == 3) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level3QuestionPage()),
                              );
                            } else if (level == 4) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level4QuestionPage()),
                              );
                            } else if (level == 5) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level5QuestionPage()),
                              );
                            } else if (level == 6) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level6QuestionPage()),
                              );
                            } else if (level == 7) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level7QuestionPage()),
                              );
                            } else if (level == 8) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level8QuestionPage()),
                              );
                            } else if (level == 9) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level9QuestionPage()),
                              );
                            } else if (level == 10) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level10QuestionPage()),
                              );
                            } else if (level == 11) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level11QuestionPage()),
                              );
                            } else if (level == 12) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level12QuestionPage()),
                              );
                            } else if (level == 13) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level13QuestionPage()),
                              );
                            } else if (level == 14) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level14QuestionPage()),
                              );
                            } else if (level == 15) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level15QuestionPage()),
                              );
                            } else if (level == 16) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level16QuestionPage()),
                              );
                            } else if (level == 17) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level17QuestionPage()),
                              );
                            } else if (level == 18) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level18QuestionPage()),
                              );
                            } else if (level == 19) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level19QuestionPage()),
                              );
                            } else if (level == 20) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level20QuestionPage()),
                              );
                            } else if (level == 21) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level21QuestionPage()),
                              );
                            } else if (level == 22) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level22QuestionPage()),
                              );
                            } else if (level == 23) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level23QuestionPage()),
                              );
                            } else if (level == 24) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level24QuestionPage()),
                              );
                            } else if (level == 25) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level25QuestionPage()),
                              );
                            } else if (level == 26) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level26QuestionPage()),
                              );
                            } else if (level == 27) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level27QuestionPage()),
                              );
                            } else if (level == 28) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level28QuestionPage()),
                              );
                            } else if (level == 29) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level29QuestionPage()),
                              );
                            } else if (level == 30) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const Level30QuestionPage()),
                              );
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => LevelPage(
                                    level: level,
                                    question: questions.length >= level
                                        ? questions[level - 1]
                                        : ' $level ',
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text('Level $level', textAlign: TextAlign.center),
                        ),
                      );
                    },
                    childCount: 30,
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
