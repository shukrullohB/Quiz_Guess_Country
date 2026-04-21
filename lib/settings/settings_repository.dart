import 'package:shared_preferences/shared_preferences.dart';

import 'app_settings.dart';

class SettingsRepository {
  static const _soundKey = 'settings.soundEnabled';
  static const _vibrationKey = 'settings.vibrationEnabled';
  static const _animationsKey = 'settings.animationsEnabled';

  Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AppSettings(
      soundEnabled:
          prefs.getBool(_soundKey) ?? AppSettings.defaults.soundEnabled,
      vibrationEnabled:
          prefs.getBool(_vibrationKey) ?? AppSettings.defaults.vibrationEnabled,
      animationsEnabled:
          prefs.getBool(_animationsKey) ??
          AppSettings.defaults.animationsEnabled,
    );
  }

  Future<void> save(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundKey, settings.soundEnabled);
    await prefs.setBool(_vibrationKey, settings.vibrationEnabled);
    await prefs.setBool(_animationsKey, settings.animationsEnabled);
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_soundKey);
    await prefs.remove(_vibrationKey);
    await prefs.remove(_animationsKey);
  }
}
