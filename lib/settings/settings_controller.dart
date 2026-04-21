import 'package:flutter/foundation.dart';

import 'app_settings.dart';
import 'settings_repository.dart';

class SettingsController extends ValueNotifier<AppSettings> {
  SettingsController({
    required SettingsRepository repository,
    required AppSettings initial,
  }) : _repository = repository,
       super(initial);

  final SettingsRepository _repository;

  Future<void> setSoundEnabled(bool value) async {
    final next = this.value.copyWith(soundEnabled: value);
    await _save(next);
  }

  Future<void> setVibrationEnabled(bool value) async {
    final next = this.value.copyWith(vibrationEnabled: value);
    await _save(next);
  }

  Future<void> setAnimationsEnabled(bool value) async {
    final next = this.value.copyWith(animationsEnabled: value);
    await _save(next);
  }

  Future<void> resetSettings() async {
    await _repository.reset();
    value = AppSettings.defaults;
    notifyListeners();
  }

  Future<void> _save(AppSettings next) async {
    await _repository.save(next);
    value = next;
    notifyListeners();
  }
}
