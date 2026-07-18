import 'package:flutter/material.dart';
import '../models/level_model.dart';
import 'base_level_controller.dart';
import 'level_generator.dart';

class Nivel6Controller extends BaseLevelController<BlindLevelModel> {
  Color? colorSeleccionado;

  Nivel6Controller({required super.nivelInicial}) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as BlindLevelModel;
  }

  void seleccionarColor(Color color) {
    if (comprobado) return;
    colorSeleccionado = color;
    notifyListeners();
  }

  @override
  bool get listoParaComprobar => colorSeleccionado != null;

  @override
  bool comprobarResultado() {
    if (colorSeleccionado == null) return false;
    comprobado = true;
    notifyListeners();
    return colorSeleccionado!.value == datosNivel.correctColor.value;
  }

  @override
  void reiniciarSeleccion() {
    colorSeleccionado = null;
    comprobado = false;
    notifyListeners();
  }

  // Matrices de color para filtros de Daltonismo (formato 4x5 de Flutter)
  List<double> get matrixFilter {
    if (datosNivel.blindType == "Protanopia") {
      return const [
        0.567, 0.433, 0.0,   0.0, 0.0,
        0.558, 0.442, 0.0,   0.0, 0.0,
        0.0,   0.242, 0.758, 0.0, 0.0,
        0.0,   0.0,   0.0,   1.0, 0.0,
      ];
    } else if (datosNivel.blindType == "Deuteranopia") {
      return const [
        0.625, 0.375, 0.0,   0.0, 0.0,
        0.7,   0.3,   0.0,   0.0, 0.0,
        0.0,   0.3,   0.7,   0.0, 0.0,
        0.0,   0.0,   0.0,   1.0, 0.0,
      ];
    } else {
      // Tritanopia (blue blindness)
      return const [
        0.95,  0.05,  0.0,   0.0, 0.0,
        0.0,   0.433, 0.567, 0.0, 0.0,
        0.0,   0.475, 0.525, 0.0, 0.0,
        0.0,   0.0,   0.0,   1.0, 0.0,
      ];
    }
  }
}
