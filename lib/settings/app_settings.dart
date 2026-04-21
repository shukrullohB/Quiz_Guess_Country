class AppSettings {
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool animationsEnabled;

  const AppSettings({
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.animationsEnabled,
  });

  static const defaults = AppSettings(
    soundEnabled: true,
    vibrationEnabled: true,
    animationsEnabled: true,
  );

  AppSettings copyWith({
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? animationsEnabled,
  }) {
    return AppSettings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
    );
  }

  Map<String, Object> toMap() {
    return {
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'animationsEnabled': animationsEnabled,
    };
  }

  factory AppSettings.fromMap(Map<String, Object?> map) {
    return AppSettings(
      soundEnabled: map['soundEnabled'] as bool? ?? true,
      vibrationEnabled: map['vibrationEnabled'] as bool? ?? true,
      animationsEnabled: map['animationsEnabled'] as bool? ?? true,
    );
  }
}
