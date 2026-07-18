import 'package:flutter/material.dart';
import '../models/level_model.dart';
import 'base_level_controller.dart';
import 'level_generator.dart';

class Nivel11Controller extends BaseLevelController<AtmosphereLevelModel> {
  List<Color>? paletaSeleccionada;

  Nivel11Controller({required super.nivelInicial}) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as AtmosphereLevelModel;
  }

  void seleccionarPaleta(List<Color> palette) {
    if (comprobado) return;
    paletaSeleccionada = palette;
    notifyListeners();
  }

  @override
  bool get listoParaComprobar => paletaSeleccionada != null;

  @override
  bool comprobarResultado() {
    if (paletaSeleccionada == null) return false;
    comprobado = true;
    notifyListeners();

    // Comprobar si los valores de color coinciden exactamente con la paleta correcta
    final List<int> correctValues = datosNivel.correctPalette.map((c) => c.value).toList();
    final List<int> selectedValues = paletaSeleccionada!.map((c) => c.value).toList();
    
    if (correctValues.length != selectedValues.length) return false;
    for (int i = 0; i < correctValues.length; i++) {
      if (correctValues[i] != selectedValues[i]) return false;
    }
    return true;
  }

  @override
  void reiniciarSeleccion() {
    paletaSeleccionada = null;
    comprobado = false;
    notifyListeners();
  }
}
