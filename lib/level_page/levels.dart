import 'dart:ui';

import 'package:flutter/material.dart';

import '../all_levels/level1.dart';
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
import '../all_levels/level2.dart';
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
import '../all_levels/level3.dart';
import '../all_levels/level30.dart';
import '../all_levels/level4.dart';
import '../all_levels/level5.dart';
import '../all_levels/level6.dart';
import '../all_levels/level7.dart';
import '../all_levels/level8.dart';
import '../all_levels/level9.dart';
import '../settings/progress_repository.dart';
import '../theme/app_colors.dart';

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

class LevelSelectPage extends StatefulWidget {
  const LevelSelectPage({super.key});

  @override
  State<LevelSelectPage> createState() => _LevelSelectPageState();
}

class _LevelSelectPageState extends State<LevelSelectPage> {
  Set<int> _completedLevels = const <int>{};
  int _highestCompletedLevel = 0;
  bool _loadingProgress = true;

  @override
  void initState() {
    super.initState();
    _loadCompleted();
  }

  Future<void> _loadCompleted() async {
    final repository = ProgressRepository();
    final levels = await repository.loadCompletedLevels();
    final storedHighest = await repository.loadHighestCompletedLevel();
    var computedHighest = storedHighest;
    for (final level in levels) {
      if (level > computedHighest) computedHighest = level;
    }
    if (!mounted) return;
    setState(() {
      _completedLevels = levels;
      _highestCompletedLevel = computedHighest;
      _loadingProgress = false;
    });
  }

  int get _nextUnlockedLevel {
    final candidate = _highestCompletedLevel + 1;
    if (candidate < 1) return 1;
    if (candidate > levelPages.length) return levelPages.length;
    return candidate;
  }

  bool _isUnlocked(int level) {
    if (level == 1) return true;
    return level <= _nextUnlockedLevel || _completedLevels.contains(level);
  }

  String _lockHint(int level) {
    final required = level - 1;
    return 'Complete Level $required to unlock Level $level.';
  }

  bool _isAllCompleted(int completedCount) => completedCount >= levelPages.length;

  Future<void> _onProgressTap(int completedCount) async {
    if (_loadingProgress) return;

    if (_isAllCompleted(completedCount)) {
      await _showAllCompletedDialog();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Keep going. Complete Level $_nextUnlockedLevel to unlock the next one.',
        ),
      ),
    );
  }

  Future<void> _showAllCompletedDialog() async {
    final restart = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.navy800,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.emoji_events, color: Color(0xFFFDE68A)),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'World Explorer Master',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          content: const Text(
            'Amazing work. You completed all 30 levels and guessed every country correctly.',
            style: TextStyle(color: Colors.white70, height: 1.35),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700),
              ),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.greenAccent,
                foregroundColor: AppColors.navy800,
              ),
              onPressed: () => Navigator.of(ctx).pop(true),
              icon: const Icon(Icons.restart_alt),
              label: const Text(
                'Play Again',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        );
      },
    );

    if (restart != true || !mounted) return;

    await ProgressRepository().reset();
    if (!mounted) return;
    await _loadCompleted();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Progress reset. Start from Level 1 again.')),
    );
  }

  Color _getLevelColor(int level) {
    final t = (level - 1) / 29;
    final hsl = HSLColor.fromAHSL(1, 120 - 120 * t, 0.85, 0.6);
    return hsl.toColor();
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _completedLevels.length;
    final allCompleted = _isAllCompleted(completedCount);

    return Scaffold(
      backgroundColor: AppColors.navy900,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF23242A), Color(0xFF3A5BA0), Color(0xFF23242A)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(color: Colors.black.withValues(alpha: 0.35)),
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
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white.withValues(alpha: 0.9),
                      letterSpacing: 0.9,
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _onProgressTap(completedCount),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white.withValues(alpha: 0.10),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
                        ),
                        child: _loadingProgress
                            ? const SizedBox(
                                height: 24,
                                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                              )
                            : Row(
                                children: [
                                  Icon(
                                    allCompleted ? Icons.workspace_premium : Icons.flag_circle,
                                    color: allCompleted
                                        ? const Color(0xFFFDE68A)
                                        : Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      allCompleted
                                          ? 'Perfect run: $completedCount/${levelPages.length}. Tap for celebration.'
                                          : 'Progress: $completedCount/${levelPages.length} completed',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: allCompleted
                                          ? const Color(0xFFF59E0B).withValues(alpha: 0.24)
                                          : AppColors.greenAccent.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: allCompleted
                                            ? const Color(0xFFFDE68A).withValues(alpha: 0.50)
                                            : AppColors.greenAccent.withValues(alpha: 0.45),
                                      ),
                                    ),
                                    child: Text(
                                      allCompleted
                                          ? 'Champion'
                                          : 'Open: Level $_nextUnlockedLevel',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(8, 2, 8, 10),
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
                      final completed = _completedLevels.contains(level);
                      final unlocked = _isUnlocked(level);
                      final tileColor = unlocked
                          ? _getLevelColor(level)
                          : const Color(0xFF38475F).withValues(alpha: 0.85);
                      return Material(
                        elevation: unlocked ? 4 : 1,
                        borderRadius: BorderRadius.circular(18),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: tileColor,
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: unlocked
                                  ? Colors.white.withValues(alpha: 0.3)
                                  : Colors.white.withValues(alpha: 0.14),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            if (!unlocked) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(_lockHint(level))),
                              );
                              return;
                            }
                            await Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => levelPages[index]),
                            );
                            if (!mounted) return;
                            _loadCompleted();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  'Level $level',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: unlocked
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.75),
                                  ),
                                ),
                              ),
                              if (completed) ...[
                                const SizedBox(width: 6),
                                const Icon(Icons.check_circle, size: 18),
                              ] else if (!unlocked) ...[
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.lock_rounded,
                                  size: 18,
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: levelPages.length,
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
