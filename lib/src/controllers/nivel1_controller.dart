import 'package:flutter/material.dart';
import '../models/level_model.dart';
import 'base_level_controller.dart';
import 'level_generator.dart';

class Nivel1Controller extends BaseLevelController<MixLevelModel> {
  Color? colorSeleccionado1;
  Color? colorSeleccionado2;

  Nivel1Controller({required super.nivelInicial}) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as MixLevelModel;
  }

  @override
  bool get listoParaComprobar => colorSeleccionado1 != null && colorSeleccionado2 != null;

  void seleccionarColor(Color color) {
    if (comprobado) return;
    if (colorSeleccionado1 == null) {
      colorSeleccionado1 = color;
    } else {
      colorSeleccionado2 ??= color;
    }
    notifyListeners();
  }

  @override
  void reiniciarSeleccion() {
    if (comprobado) return;
    colorSeleccionado1 = null;
    colorSeleccionado2 = null;
    notifyListeners();
  }

  @override
  bool comprobarResultado() {
    if (!listoParaComprobar) return false;
    comprobado = true;
    
    Color c1 = datosNivel.color1;
    Color c2 = datosNivel.color2;

    bool correcto =
        (colorSeleccionado1?.value == c1.value &&
                colorSeleccionado2?.value == c2.value) ||
            (colorSeleccionado1?.value == c2.value &&
                colorSeleccionado2?.value == c1.value);

    if (!correcto) {
      colorSeleccionado1 = null;
      colorSeleccionado2 = null;
      comprobado = false;
    }
    notifyListeners();
    return correcto;
  }
}
