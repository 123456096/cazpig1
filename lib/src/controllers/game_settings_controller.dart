import 'package:flutter/material.dart';
import '../models/game_settings_model.dart';

class GameSettingsController extends ChangeNotifier {
  GameSettingsModel _settings = GameSettingsModel.defaultSettings();

  GameSettingsModel get settings => _settings;

  void setMusicActive(bool active) {
    _settings = _settings.copyWith(musicActive: active);
    notifyListeners();
  }

  void setVibrationActive(bool active) {
    _settings = _settings.copyWith(vibrationActive: active);
    notifyListeners();
  }

  void setNotificationsActive(bool active) {
    _settings = _settings.copyWith(notificationsActive: active);
    notifyListeners();
  }

  void setLanguage(String lang) {
    _settings = _settings.copyWith(language: lang);
    notifyListeners();
  }
}
