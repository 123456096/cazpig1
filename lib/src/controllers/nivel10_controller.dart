import 'package:flutter/material.dart';
import '../models/level_model.dart';
import 'base_level_controller.dart';
import 'level_generator.dart';

class Nivel10Controller extends BaseLevelController<AlbersLevelModel> {
  Color? colorSeleccionado;

  Nivel10Controller({required super.nivelInicial}) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as AlbersLevelModel;
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
    return colorSeleccionado!.value == datosNivel.correctInnerColor.value;
  }

  @override
  void reiniciarSeleccion() {
    colorSeleccionado = null;
    comprobado = false;
    notifyListeners();
  }
}
