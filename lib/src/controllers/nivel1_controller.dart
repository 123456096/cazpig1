import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pigmento/src/controllers/user_controller.dart';
import 'package:pigmento/src/controllers/game_settings_controller.dart';
import 'package:pigmento/src/models/level_model.dart';
import 'package:pigmento/src/controllers/base_level_controller.dart';
import 'package:pigmento/src/controllers/level_generator.dart';

class PigmentInfo {
  final Color color;
  final String nombre;
  final String formula;

  const PigmentInfo({
    required this.color,
    required this.nombre,
    required this.formula,
  });
}

const List<PigmentInfo> allPigments = [
  PigmentInfo(color: Color(0xFFE53935), nombre: "Rojo Cadmio", formula: "CdSe"),
  PigmentInfo(color: Color(0xFF1E88E5), nombre: "Azul Cobalto", formula: "CoAl2O4"),
  PigmentInfo(color: Color(0xFFFFB300), nombre: "Amarillo Cromo", formula: "PbCrO4"),
  PigmentInfo(color: Color(0xFF43A047), nombre: "Verde Viridián", formula: "Cr2O3"),
  PigmentInfo(color: Colors.white, nombre: "Blanco Titanio", formula: "TiO2"),
  PigmentInfo(color: Color(0xFF212121), nombre: "Negro Carbón", formula: "C"),
];

PigmentInfo getPigmentInfo(Color color) {
  final int val = color.value;
  if (val == Colors.red.value || val == const Color(0xFFE53935).value) {
    return allPigments[0];
  }
  if (val == Colors.blue.value || val == const Color(0xFF1E88E5).value) {
    return allPigments[1];
  }
  if (val == Colors.yellow.value || val == const Color(0xFFFFB300).value) {
    return allPigments[2];
  }
  if (val == Colors.green.value || val == const Color(0xFF43A047).value) {
    return allPigments[3];
  }
  if (val == Colors.white.value) {
    return allPigments[4];
  }
  if (val == Colors.black.value || val == const Color(0xFF212121).value) {
    return allPigments[5];
  }
  return PigmentInfo(color: color, nombre: "Pigmento Especial", formula: "Unk");
}

class Nivel1Controller extends BaseLevelController<MixLevelModel> {
  final int nivelInicial;
  Color? colorSeleccionado1;
  Color? colorSeleccionado2;
  late List<PigmentInfo> opcionesPaleta;

  Nivel1Controller({required this.nivelInicial}) : super(nivelInicial: nivelInicial) {
    datosNivel = LevelGenerator.generarNivel(nivelInicial) as MixLevelModel;
    _inicializarPaleta();
  }

  void _inicializarPaleta() {
    final p1 = getPigmentInfo(datosNivel.color1);
    final p2 = getPigmentInfo(datosNivel.color2);
    final list = allPigments.where((p) => p.color.value != p1.color.value && p.color.value != p2.color.value).toList();
    list.shuffle();
    opcionesPaleta = [p1, p2, list[0], list[1]]..shuffle();
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

    final c1Val = colorSeleccionado1!.value;
    final c2Val = colorSeleccionado2!.value;

    final p1 = getPigmentInfo(datosNivel.color1);
    final p2 = getPigmentInfo(datosNivel.color2);

    final correctC1 = p1.color.value;
    final correctC2 = p2.color.value;

    // Verificar si es la mezcla correcta para el nivel
    if ((c1Val == correctC1 && c2Val == correctC2) ||
        (c1Val == correctC2 && c2Val == correctC1)) {
      nombreColorResultante = datosNivel.objective;
      esCorrecto = true;
      return datosNivel.colorHex;
    }

    // Buscar si produce alguna otra combinación en el catálogo
    for (final mezcla in LevelGenerator.mezclasBase) {
      final m1 = getPigmentInfo(mezcla["c1"]).color.value;
      final m2 = getPigmentInfo(mezcla["c2"]).color.value;
      if ((c1Val == m1 && c2Val == m2) || (c1Val == m2 && c2Val == c1Val)) {
        nombreColorResultante = mezcla["objective"];
        esCorrecto = false;
        return mezcla["colorHex"];
      }
    }

    nombreColorResultante = "Mezcla inestable";
    esCorrecto = false;

    return Color.lerp(colorSeleccionado1, colorSeleccionado2, 0.5) ?? const Color(0xFF4E443C);
  }

  void seleccionarColor(Color color) {
    if (comprobado) return;

    if (colorSeleccionado1 == color) {
      colorSeleccionado1 = null;
      notifyListeners();
      return;
    }
    if (colorSeleccionado2 == color) {
      colorSeleccionado2 = null;
      notifyListeners();
      return;
    }

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

  // ==================== PROCESAMIENTO AUTOMÁTICO Y NAVEGACIÓN ====================
  void comprobarResultadoAutomatico(BuildContext context) async {
    final _ = colorResultante; 
    final settings = GameSettingsController().settings;

    comprobado = true;
    notifyListeners();

    if (esCorrecto) {
      if (settings.musicActive) {
        try {
          AudioPlayer().play(AssetSource('audio/success.mp3'));
        } catch (e) {
          debugPrint("Error audio success: $e");
        }
      }
      if (settings.vibrationActive) {
        HapticFeedback.mediumImpact();
      }

      showDialog(
        context: context,
        barrierDismissible: false, 
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            backgroundColor: const Color(0xFF161A22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.greenAccent, width: 1.5),
            ),
            title: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 28),
                SizedBox(width: 12),
                Text("Síntesis Exitosa", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            content: Text(
              "¡Espectacular! Has logrado estabilizar el pigmento ${datosNivel.objective}. La fórmula es correcta.",
              style: const TextStyle(color: Color(0xFF6B7A94), fontSize: 14),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.greenAccent.withOpacity(0.1),
                  foregroundColor: Colors.greenAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  comprobarResultado();

                  // Se eliminó el 'await' porque el método retorna void síncrono
                  UserController().completarNivel(nivelInicial);

                  if (context.mounted) {
                    Navigator.of(dialogContext).pop(); // Cierra el modal flotante
                    Navigator.of(context).pop();      // Cierra la pantalla y vuelve al mapa
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text("Siguiente Nivel", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          );
        },
      );

    } else {
      if (settings.musicActive) {
        try {
          AudioPlayer().play(AssetSource('audio/error.mp3'));
        } catch (e) {
          debugPrint("Error audio error: $e");
        }
      }
      if (settings.vibrationActive) {
        HapticFeedback.mediumImpact();
      }

      // Se eliminó el 'await' porque el método retorna void síncrono
      UserController().restarVida();

      showDialog(
        context: context,
        barrierDismissible: false, 
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            backgroundColor: const Color(0xFF161A22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            title: const Row(
              children: [
                Icon(Icons.science_outlined, color: Colors.redAccent, size: 28),
                SizedBox(width: 12),
                Text("Síntesis Fallida", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            content: Text(
              "La reacción generó un compuesto de tipo ($nombreColorResultante) en lugar de ${datosNivel.objective}. Los reactivos se han volatilizado.",
              style: const TextStyle(color: Color(0xFF6B7A94), fontSize: 14),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.redAccent.withOpacity(0.1),
                  foregroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); 
                  comprobado = false;          
                  reiniciarSeleccion(); 
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text("Reintentar Reacción", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}