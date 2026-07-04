import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;

  SoundManager._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playSuccess() async {
    await _playAudio('audio/success.mp3');
  }

  Future<void> playError() async {
    await _playAudio('audio/error.mp3');
  }

  Future<void> playButtonTap() async {
    await _vibrate();
    await _playAudio('audio/button_tap.mp3');
  }

  Future<void> _playAudio(String assetPath) async {
    try {
      await _audioPlayer.play(AssetSource(assetPath), volume: 1.0);
    } catch (error) {
      debugPrint('SoundManager: no se pudo reproducir $assetPath => $error');
    }
  }

  Future<void> _vibrate() async {
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
}
