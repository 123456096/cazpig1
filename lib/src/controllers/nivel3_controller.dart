import 'package:flutter/material.dart';
import '../models/level_model.dart';
import 'base_level_controller.dart';
import 'level_generator.dart';

class Nivel3Controller extends BaseLevelController<GradientLevelModel> {
  late List<Map<String, dynamic>> opcionesMuestras;
  Color? colorSeleccionado;

  Nivel3Controller({required super.nivelInicial}) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as GradientLevelModel;
    
    final HSLColor correctHsl = HSLColor.fromColor(datosNivel.correctColor);
    
    double shift = (35.0 - nivelInicial * 0.35).clamp(7.0, 45.0);
    
    final Color d1 = correctHsl.withHue((correctHsl.hue + shift) % 360).toColor();
    final Color d2 = correctHsl.withHue((correctHsl.hue - shift + 360) % 360).toColor();

    opcionesMuestras = [
      {"color": datosNivel.correctColor, "nombre": "Correcto"},
      {"color": d1, "nombre": "Distractor A"},
      {"color": d2, "nombre": "Distractor B"},
    ]..shuffle();
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
    bool correcto = colorSeleccionado!.value == datosNivel.correctColor.value;
    notifyListeners();
    return correcto;
  }
}
