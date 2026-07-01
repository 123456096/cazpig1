class GameSettingsModel {
  final bool musicActive;
  final bool vibrationActive;
  final bool notificationsActive;
  final String language;

  GameSettingsModel({
    required this.musicActive,
    required this.vibrationActive,
    required this.notificationsActive,
    required this.language,
  });

  GameSettingsModel copyWith({
    bool? musicActive,
    bool? vibrationActive,
    bool? notificationsActive,
    String? language,
  }) {
    return GameSettingsModel(
      musicActive: musicActive ?? this.musicActive,
      vibrationActive: vibrationActive ?? this.vibrationActive,
      notificationsActive: notificationsActive ?? this.notificationsActive,
      language: language ?? this.language,
    );
  }

  factory GameSettingsModel.defaultSettings() {
    return GameSettingsModel(
      musicActive: true,
      vibrationActive: true,
      notificationsActive: false,
      language: "Español (ES)",
    );
  }
}
