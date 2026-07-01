import 'package:flutter/material.dart';
import '../models/level_model.dart';

class LevelGenerator {
  // Catálogo de mezclas para el modo Mezcla Cromática
  static final List<Map<String, dynamic>> _mezclasBase = [
    {"objective": "VIOLETA", "colorHex": const Color(0xFF7B1FA2), "instruction": "Combina rojo + azul", "c1": Colors.red, "c2": Colors.blue},
    {"objective": "VERDE", "colorHex": const Color(0xFF388E3C), "instruction": "Combina azul + amarillo", "c1": Colors.blue, "c2": Colors.yellow},
    {"objective": "NARANJA", "colorHex": const Color(0xFFF57C00), "instruction": "Combina rojo + amarillo", "c1": Colors.red, "c2": Colors.yellow},
    {"objective": "ROSA", "colorHex": const Color(0xFFF48FB1), "instruction": "Combina rojo + blanco", "c1": Colors.red, "c2": Colors.white},
    {"objective": "AZUL CLARO", "colorHex": const Color(0xFF81D4FA), "instruction": "Combina azul + blanco", "c1": Colors.blue, "c2": Colors.white},
    {"objective": "VERDE CLARO", "colorHex": const Color(0xFFA5D6A7), "instruction": "Combina verde + blanco", "c1": Colors.green, "c2": Colors.white},
    {"objective": "AMARILLO CLARO", "colorHex": const Color(0xFFFFF59D), "instruction": "Combina amarillo + blanco", "c1": Colors.yellow, "c2": Colors.white},
    {"objective": "VERDE OSCURO", "colorHex": const Color(0xFF1B5E20), "instruction": "Combina verde + azul", "c1": Colors.green, "c2": Colors.blue},
    {"objective": "TURQUESA", "colorHex": const Color(0xFF00BEC4), "instruction": "Combina azul + verde", "c1": Colors.blue, "c2": Colors.green},
    {"objective": "GRIS", "colorHex": const Color(0xFF8E8E93), "instruction": "Combina blanco + negro", "c1": Colors.white, "c2": Colors.black},
    {"objective": "MARRÓN", "colorHex": const Color(0xFF795548), "instruction": "Combina rojo + verde", "c1": Colors.red, "c2": Colors.green},
    {"objective": "PÚRPURA OSCURO", "colorHex": const Color(0xFF4A148C), "instruction": "Combina azul + rojo", "c1": Colors.blue, "c2": Colors.red},
    {"objective": "CREMA", "colorHex": const Color(0xFFFFF8E1), "instruction": "Combina amarillo + blanco", "c1": Colors.yellow, "c2": Colors.white},
  ];

  // Catálogo de briefs para el modo Branding
  static final List<Map<String, dynamic>> _briefsBase = [
    {"context": "TECNOLOGÍA Y SALUD", "brief": "El cliente exige proyectar alta confianza, seguridad institucional, estabilidad y lógica científica. ¿Qué matiz es el ideal?", "correct": Colors.blue, "name": "Azul Corporativo"},
    {"context": "CADENA DE FAST FOOD", "brief": "Se busca activar el apetito inmediato de los consumidores de forma masiva y veloz. Selecciona el pigmento estimulante visceral:", "correct": Colors.red, "name": "Rojo Impulsivo"},
    {"context": "LÍNEA DE PRODUCTOS ECO", "brief": "Identidad visual basada en la sustentabilidad, el desarrollo orgánico y el equilibrio natural. ¿Cuál es su color base?", "correct": Colors.green, "name": "Verde Orgánico"},
    {"context": "BOUTIQUE DE LUJO EXCLUSIVO", "brief": "Diseño premium que busca representar elegancia absoluta, sofisticación, solemnidad y alto estatus económico sin distracciones.", "correct": const Color(0xFF000000), "name": "Negro Absoluto"},
    {"context": "ESTUDIO CREATIVO O AGENCIA", "brief": "Se requiere comunicar innovación constante, juventud, diversión, dinamismo y un alto factor de asombro intelectual.", "correct": Colors.orange, "name": "Naranja Innovación"},
    {"context": "MARCA INFANTIL Y JUGUETES", "brief": "El brief pide denotar diversión pura, energía radiante, optimismo, estímulo mental temprano y mucha luz ambiental.", "correct": Colors.yellow, "name": "Amarillo Optimismo"},
    {"context": "PRODUCTOS DE CUIDADO FEMENINO", "brief": "Estética contemporánea orientada a la delicadeza, suavidad, romanticismo, calma afectiva y empatía visual.", "correct": Colors.pink, "name": "Rosa Suavidad"},
    {"context": "SPA Y CENTRO DE MEDITACIÓN", "brief": "Identidad que busca inducir un estado de relajación mental absoluta, equilibrio espiritual, transmutación y paz.", "correct": Colors.purple, "name": "Violeta Zen"},
    {"context": "LÍNEA DE MAQUILLAJE CLÍNICO", "brief": "Marca que ensalza la pureza, limpieza total, inocencia clínica, transparencia y minimalismo absoluto.", "correct": Colors.white, "name": "Blanco Puro"},
    {"context": "EDITORIAL DE HISTORIA Y ARQUEOLOGÍA", "brief": "Se desea transmitir tradición ancestral, conexión con las raíces, calidez rústica y durabilidad en el tiempo.", "correct": const Color(0xFF8B4513), "name": "Café Tradición"},
    {"context": "SISTEMAS DE CIBERSEGURIDAD", "brief": "La marca debe infundir confidencialidad hermética, autoridad tecnológica y profundidad informática. Elige el tono idóneo:", "correct": const Color(0xFF1A237E), "name": "Azul Marino Profundo"},
    {"context": "BEBIDAS ENERGÉTICAS", "brief": "Se busca emitir adrenalina pura, potencia física, peligro controlado y máxima estimulación nocturna.", "correct": const Color(0xFFCCFF00), "name": "Verde Neón Energético"},
    {"context": "LÍNEA DE PASTELERÍA INGLESA", "brief": "Identidad que busca proyectar dulzura artesanal, calidez hogareña y un matiz sutilmente azucarado y elegante.", "correct": const Color(0xFFF8BBD0), "name": "Rosa Pastel Algodón"},
    {"context": "DENTAL CLINIC", "brief": "Se requiere proyectar higiene dental, aire fresco, tranquilidad clínica y profesionalismo moderno.", "correct": Colors.teal, "name": "Verde Azulado Menta"},
  ];

  // Catálogo de parejas de colores para el modo Degradados
  static final List<List<Color>> _parejasDegradados = [
    [const Color(0xFFFFEBEE), const Color(0xFFE57373)], // Rosa/Rojo
    [const Color(0xFFE3F2FD), const Color(0xFF64B5F6)], // Celeste/Azul
    [const Color(0xFFE8F5E9), const Color(0xFF81C784)], // Verde Claro/Verde
    [Colors.yellow, Colors.red],                        // Amarillo/Rojo
    [const Color(0xFF311B92), const Color(0xFF5E35B1)], // Violeta
    [const Color(0xFFFFF8E1), const Color(0xFFFFD54F)], // Crema/Amarillo
    [const Color(0xFF006064), const Color(0xFF00ACC1)], // Turquesa/Cian
    [const Color(0xFFF1F8E9), const Color(0xFFAEDB97)], // Lima
    [const Color(0xFF3E2723), const Color(0xFF6D4C41)], // Tierra/Marrón
    [const Color(0xFFECEFF1), const Color(0xFF78909C)], // Gris Frío
    [const Color(0xFFFFF3E0), const Color(0xFFFFB74D)], // Naranja
  ];

  // Catálogo de contrastes de accesibilidad WCAG
  static final List<Map<String, dynamic>> _contrastesBase = [
    {
      "question": "Selecciona el color con MEJOR LEGIBILIDAD sobre este fondo amarillo vibrante:",
      "bg": const Color(0xFFFFD166),
      "correct": const Color(0xFF1D2434),
      "options": [
        const Color(0xFFFFFFFF),
        const Color(0xFFECEFF1),
        const Color(0xFF1D2434),
        const Color(0xFFA5D6A7),
      ],
      "explanation": "El fondo amarillo es muy claro. Necesitas un color muy oscuro (alta relación de contraste) para que el texto sea legible y no canse la vista."
    },
    {
      "question": "Elige el texto de máxima legibilidad sobre este fondo azul marino profundo:",
      "bg": const Color(0xFF1A237E),
      "correct": const Color(0xFFFFFFFF),
      "options": [
        const Color(0xFF3F51B5),
        const Color(0xFF212121),
        const Color(0xFFFFFFFF),
        const Color(0xFF4E586E),
      ],
      "explanation": "Los fondos oscuros requieren texto blanco o de tonalidades sumamente claras para cumplir con los estándares de accesibilidad WCAG."
    },
    {
      "question": "Selecciona el color de texto ideal para este fondo verde neón muy brillante:",
      "bg": const Color(0xFFCCFF00),
      "correct": const Color(0xFF000000),
      "options": [
        const Color(0xFF000000),
        const Color(0xFFFFFFFF),
        const Color(0xFF81C784),
        const Color(0xFFFFF59D),
      ],
      "explanation": "El verde neón tiene una luminancia muy alta, por lo que el negro puro ofrece la mejor legibilidad y previene la fatiga visual."
    },
    {
      "question": "Selecciona el texto más legible sobre este fondo rojo saturado de marca:",
      "bg": const Color(0xFFD50000),
      "correct": const Color(0xFFFFFFFF),
      "options": [
        const Color(0xFFE57373),
        const Color(0xFFFFFFFF),
        const Color(0xFF795548),
        const Color(0xFF263238),
      ],
      "explanation": "Sobre fondos rojos sumamente saturados, el texto blanco limpio destaca con máxima nitidez e inmediatez de lectura."
    },
    {
      "question": "Selecciona el color de texto óptimo para este fondo gris claro minimalista:",
      "bg": const Color(0xFFECEFF1),
      "correct": const Color(0xFF263238),
      "options": [
        const Color(0xFFFFFFFF),
        const Color(0xFF90A4AE),
        const Color(0xFF263238),
        const Color(0xFFB0BEC5),
      ],
      "explanation": "Para un fondo gris claro, el color del texto debe tener una luminancia muy baja, como el gris grafito oscuro o negro."
    },
  ];

  /// Obtiene la configuración de un nivel según el número N
  static dynamic generarNivel(int nivel) {
    int tipo = nivel % 4; // Rotamos entre 4 tipos de niveles

    if (tipo == 1) {
      // Mezclas
      int idx = (nivel ~/ 4) % _mezclasBase.length;
      final base = _mezclasBase[idx];
      return MixLevelModel(
        level: nivel,
        objective: base["objective"],
        colorHex: base["colorHex"],
        instruction: base["instruction"],
        color1: base["c1"],
        color2: base["c2"],
      );
    } else if (tipo == 2) {
      // Buscar / Branding
      int idx = (nivel ~/ 4) % _briefsBase.length;
      final base = _briefsBase[idx];
      return SearchLevelModel(
        level: nivel,
        instruction: base["brief"],
        context: base["context"],
        correctColor: base["correct"],
        colorName: base["name"],
      );
    } else if (tipo == 3) {
      // Degradados
      int idx = (nivel ~/ 4) % _parejasDegradados.length;
      final coloresExtremos = _parejasDegradados[idx];

      int largoSecuencia = 4;
      if (nivel > 15) largoSecuencia = 5;
      if (nivel > 30) largoSecuencia = 6;

      List<Color> secuenciaCompleta = [];
      for (int i = 0; i < largoSecuencia; i++) {
        double t = i / (largoSecuencia - 1);
        Color colorPaso = Color.lerp(coloresExtremos[0], coloresExtremos[1], t)!;
        secuenciaCompleta.add(colorPaso);
      }

      int blankIndex = 1;
      if (largoSecuencia > 4) {
        blankIndex = 1 + (nivel % (largoSecuencia - 2));
      }

      Color colorCorrecto = secuenciaCompleta[blankIndex];

      List<Color> secuenciaConVacio = List.from(secuenciaCompleta);
      secuenciaConVacio[blankIndex] = Colors.transparent;

      return GradientLevelModel(
        level: nivel,
        sequence: secuenciaConVacio,
        correctColor: colorCorrecto,
        colorName: "Paso de color intermedio",
      );
    } else {
      // Contraste Cromático / Legibilidad (tipo == 0)
      int idx = (nivel ~/ 4) % _contrastesBase.length;
      final base = _contrastesBase[idx];
      return ContrastLevelModel(
        level: nivel,
        instruction: base["question"],
        backgroundColor: base["bg"],
        correctTextColor: base["correct"],
        options: List<Color>.from(base["options"]),
        explanation: base["explanation"],
      );
    }
  }
}
