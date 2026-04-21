import 'package:flutter_test/flutter_test.dart';
import 'package:quiz/settings/app_settings.dart';
import 'package:quiz/settings/progress_repository.dart';
import 'package:quiz/settings/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('AppSettings serialize/deserialize', () {
    const settings = AppSettings(
      soundEnabled: false,
      vibrationEnabled: true,
      animationsEnabled: false,
    );

    final map = settings.toMap();
    final parsed = AppSettings.fromMap(map);

    expect(parsed.soundEnabled, false);
    expect(parsed.vibrationEnabled, true);
    expect(parsed.animationsEnabled, false);
  });

  test('SettingsRepository save/load/reset', () async {
    SharedPreferences.setMockInitialValues({});
    final repository = SettingsRepository();

    const custom = AppSettings(
      soundEnabled: false,
      vibrationEnabled: false,
      animationsEnabled: true,
    );

    await repository.save(custom);
    final loaded = await repository.load();

    expect(loaded.soundEnabled, false);
    expect(loaded.vibrationEnabled, false);
    expect(loaded.animationsEnabled, true);

    await repository.reset();
    final defaults = await repository.load();

    expect(defaults.soundEnabled, true);
    expect(defaults.vibrationEnabled, true);
    expect(defaults.animationsEnabled, true);
  });

  test('ProgressRepository reset clears only progress keys', () async {
    SharedPreferences.setMockInitialValues({
      'settings.soundEnabled': false,
    });

    final repository = ProgressRepository();
    await repository.markCompleted(3);
    await repository.markCompleted(5);

    expect(await repository.loadHighestCompletedLevel(), 5);
    expect(await repository.loadCompletedLevels(), containsAll({3, 5}));

    await repository.reset();

    expect(await repository.loadCompletedLevels(), isEmpty);
    expect(await repository.loadHighestCompletedLevel(), 0);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('settings.soundEnabled'), false);
  });
}
