import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_settings_model.dart';

class GameSettingsController extends ChangeNotifier {
  static final GameSettingsController _instance = GameSettingsController._internal();
  factory GameSettingsController() => _instance;

  GameSettingsController._internal() {
    _cargarAjustes();
  }

  GameSettingsModel _settings = GameSettingsModel.defaultSettings();

  GameSettingsModel get settings => _settings;

  Future<void> _cargarAjustes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _settings = GameSettingsModel(
        musicActive: prefs.getBool("settings_music") ?? true,
        vibrationActive: prefs.getBool("settings_vibration") ?? true,
        notificationsActive: prefs.getBool("settings_notifications") ?? true,
        language: prefs.getString("settings_language") ?? "Español",
      );
      notifyListeners();
    } catch (e) {
      debugPrint("Error al cargar ajustes locales: $e");
    }
  }

  Future<void> _guardarAjustes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("settings_music", _settings.musicActive);
      await prefs.setBool("settings_vibration", _settings.vibrationActive);
      await prefs.setBool("settings_notifications", _settings.notificationsActive);
      await prefs.setString("settings_language", _settings.language);
    } catch (e) {
      debugPrint("Error al guardar ajustes locales: $e");
    }
  }

  void setMusicActive(bool active) {
    _settings = _settings.copyWith(musicActive: active);
    _guardarAjustes();
    notifyListeners();
  }

  void setVibrationActive(bool active) {
    _settings = _settings.copyWith(vibrationActive: active);
    _guardarAjustes();
    notifyListeners();
  }

  void setNotificationsActive(bool active) {
    _settings = _settings.copyWith(notificationsActive: active);
    _guardarAjustes();
    notifyListeners();
  }

  void setLanguage(String lang) {
    _settings = _settings.copyWith(language: lang);
    _guardarAjustes();
    notifyListeners();
  }
}
