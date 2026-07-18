import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'game_settings_controller.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;

  SoundManager._internal();

  // Un player dedicado por sonido evita conflictos de estado en Chrome
  final AudioPlayer _successPlayer = AudioPlayer();
  final AudioPlayer _errorPlayer = AudioPlayer();
  final AudioPlayer _tapPlayer = AudioPlayer();

  Future<void> playSuccess() async {
    await _vibrate();
    await _playAudio(_successPlayer, 'audio/success.mp3');
  }

  Future<void> playError() async {
    await _vibrate();
    await _playAudio(_errorPlayer, 'audio/error.mp3');
  }

  Future<void> playButtonTap() async {
    await _vibrate();
    await _playAudio(_tapPlayer, 'audio/button_tap.mp3');
  }

  /// En web, AssetSource no resuelve el MIME type correctamente y Chrome
  /// rechaza el audio con "Format error (Code: 4)".
  /// UrlSource con la ruta de assets de Flutter sí funciona en web.
  Source _buildSource(String assetPath) {
    if (kIsWeb) {
      // Flutter web sirve los assets en 'assets/<ruta>'
      return UrlSource('assets/$assetPath');
    }
    return AssetSource(assetPath);
  }

  Future<void> _playAudio(AudioPlayer player, String assetPath) async {
    if (!GameSettingsController().settings.musicActive) return;
    try {
      await player.stop();
      await player.play(_buildSource(assetPath), volume: 1.0);
    } catch (error) {
      debugPrint('SoundManager: no se pudo reproducir $assetPath => $error');
    }
  }

  Future<void> _vibrate() async {
    if (!GameSettingsController().settings.vibrationActive) return;
    // La vibración no está disponible en web
    if (kIsWeb) {
      await HapticFeedback.selectionClick();
      return;
    }
    try {
      final hasVibrator = await Vibration.hasVibrator() ?? false;
      if (hasVibrator) {
        final hasAmplitudeControl = await Vibration.hasAmplitudeControl() ?? false;
        if (hasAmplitudeControl) {
          await Vibration.vibrate(duration: 20, amplitude: 128);
        } else {
          await Vibration.vibrate(duration: 20);
        }
      } else {
        await HapticFeedback.selectionClick();
      }
    } catch (error) {
      debugPrint('SoundManager: vibración no disponible => $error');
      await HapticFeedback.selectionClick();
    }
  }

  void dispose() {
    _successPlayer.dispose();
    _errorPlayer.dispose();
    _tapPlayer.dispose();
  }
}
