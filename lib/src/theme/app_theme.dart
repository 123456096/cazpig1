import 'package:flutter/material.dart';

class AppTheme {
  // Degradado colorido del juego (efecto Glow)
  static final Gradient degradadoGlow = LinearGradient(
    colors: [
      Colors.amber.shade400,
      Colors.orange.shade400,
      Colors.deepOrange.shade300, // Sustituto de Colors.coral
      Colors.pinkAccent.shade100,
      Colors.purpleAccent.shade100,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Fondo degradado pastel usado en Splash y Registro
  static const Gradient fondoPastel = LinearGradient(
    colors: [
      Color(0xffFFA2A2),
      Color(0xffFFF085),
      Color(0xffA4F4CF),
      Color(0xffB8E6FE),
      Color(0xffDAB2FF),
      Color(0xffFFCCD3),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
