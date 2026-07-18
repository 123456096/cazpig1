import 'package:flutter/material.dart';
import '../models/level_model.dart';
import 'base_level_controller.dart';
import 'level_generator.dart';

class Nivel8Controller extends BaseLevelController<TempLevelModel> {
  List<Color> available = [];
  List<Color> warm = [];
  List<Color> cold = [];

  Nivel8Controller({required super.nivelInicial}) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as TempLevelModel;
    available = List<Color>.from(datosNivel.allOptions);
  }

  void classifyColor(Color color, String zone) {
    if (comprobado) return;
    
    // Remover de todas las listas
    available.remove(color);
    warm.remove(color);
    cold.remove(color);
    
    if (zone == "warm") {
      warm.add(color);
    } else if (zone == "cold") {
      cold.add(color);
    } else {
      available.add(color);
    }
    notifyListeners();
  }

  @override
  bool get listoParaComprobar => available.isEmpty;

  @override
  bool comprobarResultado() {
    comprobado = true;
    notifyListeners();

    // Comprobar que todos los colocados en warm estén realmente en warmColors
    final List<int> correctWarmValues = datosNivel.warmColors.map((c) => c.value).toList();
    final List<int> correctColdValues = datosNivel.coldColors.map((c) => c.value).toList();

    for (var c in warm) {
      if (!correctWarmValues.contains(c.value)) return false;
    }
    for (var c in cold) {
      if (!correctColdValues.contains(c.value)) return false;
    }
    return true;
  }

  @override
  void reiniciarSeleccion() {
    available = List<Color>.from(datosNivel.allOptions);
    warm.clear();
    cold.clear();
    comprobado = false;
    notifyListeners();
  }
}
