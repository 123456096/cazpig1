import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/level_model.dart';
import 'base_level_controller.dart';
import 'level_generator.dart';

class Nivel7Controller extends BaseLevelController<RgbLevelModel> {
  double r = 128.0;
  double g = 128.0;
  double b = 128.0;

  Nivel7Controller({required super.nivelInicial}) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as RgbLevelModel;
  }

  void updateRed(double value) {
    if (comprobado) return;
    r = value;
    notifyListeners();
  }

  void updateGreen(double value) {
    if (comprobado) return;
    g = value;
    notifyListeners();
  }

  void updateBlue(double value) {
    if (comprobado) return;
    b = value;
    notifyListeners();
  }

  Color get currentColor => Color.fromARGB(255, r.toInt(), g.toInt(), b.toInt());

  double get similarity {
    final Color target = datosNivel.targetColor;
    final double dist = math.sqrt(
      math.pow(r - target.r * 255.0, 2) +
      math.pow(g - target.g * 255.0, 2) +
      math.pow(b - target.b * 255.0, 2)
    );
    return (100.0 - (dist / 441.67 * 100.0)).clamp(0.0, 100.0);
  }

  String get feedbackMessage {
    final double sim = similarity;
    if (sim >= 95) return "¡Color perfecto! Casi idéntico.";
    if (sim >= 87) return "¡Muy cerca! Excelente precisión.";
    if (sim >= 75) return "¡Tibio! Vas por muy buen camino.";
    if (sim >= 55) return "Templado. Sigue ajustando.";
    return "Frío. Ajusta los colores base.";
  }

  @override
  bool get listoParaComprobar => true;

  @override
  bool comprobarResultado() {
    comprobado = true;
    notifyListeners();

    final Color target = datosNivel.targetColor;
    
    // Distancia Euclidiana tridimensional
    final double dist = math.sqrt(
      math.pow(r - target.r * 255.0, 2) +
      math.pow(g - target.g * 255.0, 2) +
      math.pow(b - target.b * 255.0, 2)
    );

    // Si la distancia es menor a 55, se considera exitoso (tolerancia ampliada)
    return dist < 55.0;
  }

  @override
  void reiniciarSeleccion() {
    r = 128.0;
    g = 128.0;
    b = 128.0;
    comprobado = false;
    notifyListeners();
  }
}
