import 'package:flutter/material.dart';
import '../models/level_model.dart';
import 'base_level_controller.dart';
import 'level_generator.dart';

class Nivel4Controller extends BaseLevelController<ContrastLevelModel> {
  late List<Color> opciones;
  Color? colorSeleccionado;

  Nivel4Controller({required super.nivelInicial}) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as ContrastLevelModel;
    opciones = List<Color>.from(datosNivel.options)..shuffle();
  }

  @override
  bool get listoParaComprobar => colorSeleccionado != null;

  void seleccionarColor(Color color) {
    if (comprobado) return;
    colorSeleccionado = color;
    notifyListeners();
  }

  @override
  void reiniciarSeleccion() {
    if (comprobado) return;
    colorSeleccionado = null;
    notifyListeners();
  }

  @override
  bool comprobarResultado() {
    if (!listoParaComprobar) return false;
    comprobado = true;
    bool correcto = colorSeleccionado!.value == datosNivel.correctTextColor.value;
    notifyListeners();
    return correcto;
  }
}
