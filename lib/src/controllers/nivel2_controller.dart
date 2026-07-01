import 'package:flutter/material.dart';
import '../models/level_model.dart';
import 'base_level_controller.dart';
import 'level_generator.dart';

class Nivel2Controller extends BaseLevelController<SearchLevelModel> {
  late List<Map<String, dynamic>> opciones;
  Color? colorSeleccionado;

  Nivel2Controller({required super.nivelInicial}) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as SearchLevelModel;
    
    final HSLColor correctHsl = HSLColor.fromColor(datosNivel.correctColor);
    
    double shift = (40.0 - nivelInicial * 0.4).clamp(8.0, 45.0);
    
    final Color d1 = correctHsl.withHue((correctHsl.hue + shift) % 360).toColor();
    final Color d2 = correctHsl.withHue((correctHsl.hue - shift + 360) % 360).toColor();
    final Color d3 = correctHsl.withLightness((correctHsl.lightness > 0.5) 
        ? correctHsl.lightness - 0.25 
        : correctHsl.lightness + 0.25).toColor();

    opciones = [
      {"color": datosNivel.correctColor, "nombre": datosNivel.colorName},
      {"color": d1, "nombre": "Matiz Alterno A"},
      {"color": d2, "nombre": "Matiz Alterno B"},
      {"color": d3, "nombre": "Muestra Tonal C"},
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
