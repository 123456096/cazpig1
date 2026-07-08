import 'package:flutter/material.dart';
import '../models/level_model.dart';
import 'base_level_controller.dart';
import 'level_generator.dart';

class Nivel1Controller extends BaseLevelController<MixLevelModel> {
  Color? colorSeleccionado1;
  Color? colorSeleccionado2;

  static const Color rojoCadmio = Color(0xFFE53935);
  static const Color azulCobalto = Color(0xFF1E88E5);
  static const Color amarilloCazador = Color(0xFFFFB300);
  static const Color verdeCazador = Color(0xFF43A047);

  Nivel1Controller({required super.nivelInicial}) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as MixLevelModel;
  }

  bool esCorrecto = false;

  String nombreColorResultante = "Sin mezcla";

  @override
  bool get listoParaComprobar =>
      colorSeleccionado1 != null && colorSeleccionado2 != null;

  Color get colorResultante {
    if (colorSeleccionado1 == null || colorSeleccionado2 == null) {
      nombreColorResultante = "Sin mezcla";
      esCorrecto = false;
      return Colors.transparent;
    }

    final c1 = colorSeleccionado1!.value;
    final c2 = colorSeleccionado2!.value;

    // ROJO + AZUL = VIOLETA
    if ((c1 == rojoCadmio.value && c2 == azulCobalto.value) ||
        (c1 == azulCobalto.value && c2 == rojoCadmio.value)) {
      nombreColorResultante = "Violeta";
      esCorrecto = true;
      return const Color(0xFF8E24AA);
    }

    // AZUL + AMARILLO = VERDE
    if ((c1 == azulCobalto.value && c2 == amarilloCazador.value) ||
        (c1 == amarilloCazador.value && c2 == azulCobalto.value)) {
      nombreColorResultante = "Verde";
      esCorrecto = false;
      return const Color(0xFF2E7D32);
    }

    // ROJO + AMARILLO = NARANJA
    if ((c1 == rojoCadmio.value && c2 == amarilloCazador.value) ||
        (c1 == amarilloCazador.value && c2 == rojoCadmio.value)) {
      nombreColorResultante = "Naranja";
      esCorrecto = false;
      return const Color(0xFFEF6C00);
    }

    // ROJO + VERDE
    if ((c1 == rojoCadmio.value && c2 == verdeCazador.value) ||
        (c1 == verdeCazador.value && c2 == rojoCadmio.value)) {
      nombreColorResultante = "Café";
      esCorrecto = false;
      return const Color(0xFF6D4C41);
    }

    // AZUL + VERDE
    if ((c1 == azulCobalto.value && c2 == verdeCazador.value) ||
        (c1 == verdeCazador.value && c2 == azulCobalto.value)) {
      nombreColorResultante = "Turquesa";
      esCorrecto = false;
      return const Color(0xFF00897B);
    }

    // AMARILLO + VERDE
    if ((c1 == amarilloCazador.value && c2 == verdeCazador.value) ||
        (c1 == verdeCazador.value && c2 == amarilloCazador.value)) {
      nombreColorResultante = "Verde Lima";
      esCorrecto = false;
      return const Color(0xFF9CCC65);
    }

    nombreColorResultante = "Color desconocido";
    esCorrecto = false;

    return const Color(0xFF4E443C);
  }

  void seleccionarColor(Color color) {
    if (comprobado) return;

    if (colorSeleccionado1 == color) return;

    if (colorSeleccionado1 == null) {
      colorSeleccionado1 = color;
    } else if (colorSeleccionado2 == null) {
      colorSeleccionado2 = color;
    }

    notifyListeners();
  }

  @override
  void reiniciarSeleccion() {
    colorSeleccionado1 = null;
    colorSeleccionado2 = null;
    nombreColorResultante = "Sin mezcla";
    esCorrecto = false;
    notifyListeners();
  }

  @override
  bool comprobarResultado() {
    if (!listoParaComprobar) return false;

    comprobado = true;

    bool correcto = esCorrecto;

    if (!correcto) {
      comprobado = false;
    }

    notifyListeners();

    return correcto;
  }
}