import 'package:flutter/material.dart';
import '../models/level_model.dart';

abstract class BaseLevelController<T extends LevelModel> extends ChangeNotifier {
  final int nivelInicial;
  late T datosNivel;
  bool comprobado = false;

  BaseLevelController({required this.nivelInicial});

  // Indica si la selección actual es suficiente para comprobar
  bool get listoParaComprobar;

  // Realiza la validación y retorna si es correcta
  bool comprobarResultado();

  // Reinicia la selección
  void reiniciarSeleccion();
}
