import 'package:shared_preferences/shared_preferences.dart';

class ProgressRepository {
  static const completedLevelsKey = 'progress.completedLevels';
  static const highestCompletedLevelKey = 'progress.highestCompletedLevel';

  Future<Set<int>> loadCompletedLevels() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(completedLevelsKey) ?? const <String>[];
    return raw.map(int.tryParse).whereType<int>().toSet();
  }

  Future<int> loadHighestCompletedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(highestCompletedLevelKey) ?? 0;
  }

  Future<void> markCompleted(int level) async {
    final prefs = await SharedPreferences.getInstance();
    final completed = await loadCompletedLevels();
    completed.add(level);
    final highest = completed.isEmpty
        ? 0
        : completed.reduce((a, b) => a > b ? a : b);
    await prefs.setStringList(
      completedLevelsKey,
      completed.map((e) => e.toString()).toList()..sort(),
    );
    await prefs.setInt(highestCompletedLevelKey, highest);
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(completedLevelsKey);
    await prefs.remove(highestCompletedLevelKey);
  }
}
