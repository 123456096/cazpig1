import 'package:flutter/material.dart';
import '../models/level_model.dart';
import 'base_level_controller.dart';
import 'level_generator.dart';

class Nivel12Controller extends BaseLevelController<SaturationLevelModel> {
  List<Color> seleccion = [];

  Nivel12Controller({required super.nivelInicial}) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as SaturationLevelModel;
  }

  void toggleColor(Color color) {
    if (comprobado) return;
    if (seleccion.contains(color)) {
      seleccion.remove(color);
    } else {
      if (seleccion.length < datosNivel.sequence.length) {
        seleccion.add(color);
      }
    }
    notifyListeners();
  }

  @override
  bool get listoParaComprobar => seleccion.length == datosNivel.sequence.length;

  @override
  bool comprobarResultado() {
    if (seleccion.length != datosNivel.sequence.length) return false;
    comprobado = true;
    notifyListeners();

    for (int i = 0; i < datosNivel.sequence.length; i++) {
      if (seleccion[i].value != datosNivel.sequence[i].value) {
        return false;
      }
    }
    return true;
  }

  @override
  void reiniciarSeleccion() {
    seleccion.clear();
    comprobado = false;
    notifyListeners();
  }
}
