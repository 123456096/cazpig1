import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/level_model.dart';

class LevelGenerator {
  // Catálogo de mezclas para el modo Mezcla Cromática (Nivel 1)
  static final List<Map<String, dynamic>> mezclasBase = [
    {"objective": "VIOLETA", "colorHex": const Color(0xFF8E24AA), "instruction": "Combina azul + rojo", "c1": const Color(0xFF1E88E5), "c2": const Color(0xFFE53935)},
    {"objective": "NARANJA", "colorHex": const Color(0xFFF57C00), "instruction": "Combina rojo + amarillo", "c1": const Color(0xFFE53935), "c2": const Color(0xFFFFB300)},
    {"objective": "MARRÓN", "colorHex": const Color(0xFF795548), "instruction": "Combina rojo + verde", "c1": const Color(0xFFE53935), "c2": const Color(0xFF43A047)},
    {"objective": "ROSA", "colorHex": const Color(0xFFF48FB1), "instruction": "Combina rojo + blanco", "c1": const Color(0xFFE53935), "c2": Colors.white},
    {"objective": "ROJO OSCURO", "colorHex": const Color(0xFF800000), "instruction": "Combina rojo + negro", "c1": const Color(0xFFE53935), "c2": const Color(0xFF212121)},
    {"objective": "VERDE", "colorHex": const Color(0xFF4CAF50), "instruction": "Combina azul + amarillo", "c1": const Color(0xFF1E88E5), "c2": const Color(0xFFFFB300)},
    {"objective": "TURQUESA", "colorHex": const Color(0xFF00BEC4), "instruction": "Combina azul + verde", "c1": const Color(0xFF1E88E5), "c2": const Color(0xFF43A047)},
    {"objective": "AZUL CLARO", "colorHex": const Color(0xFF81D4FA), "instruction": "Combina azul + blanco", "c1": const Color(0xFF1E88E5), "c2": Colors.white},
    {"objective": "AZUL OSCURO", "colorHex": const Color(0xFF0D47A1), "instruction": "Combina azul + negro", "c1": const Color(0xFF1E88E5), "c2": const Color(0xFF212121)},
    {"objective": "LIMA", "colorHex": const Color(0xFFCDDC39), "instruction": "Combina amarillo + verde", "c1": const Color(0xFFFFB300), "c2": const Color(0xFF43A047)},
    {"objective": "AMARILLO CLARO", "colorHex": const Color(0xFFFFF59D), "instruction": "Combina amarillo + blanco", "c1": const Color(0xFFFFB300), "c2": Colors.white},
    {"objective": "MOSTAZA", "colorHex": const Color(0xFFC5A059), "instruction": "Combina amarillo + negro", "c1": const Color(0xFFFFB300), "c2": const Color(0xFF212121)},
    {"objective": "VERDE CLARO", "colorHex": const Color(0xFFA5D6A7), "instruction": "Combina verde + blanco", "c1": const Color(0xFF43A047), "c2": Colors.white},
    {"objective": "VERDE OSCURO", "colorHex": const Color(0xFF1B5E20), "instruction": "Combina verde + negro", "c1": const Color(0xFF43A047), "c2": const Color(0xFF212121)},
    {"objective": "GRIS", "colorHex": const Color(0xFF8E8E93), "instruction": "Combina blanco + negro", "c1": Colors.white, "c2": const Color(0xFF212121)},
  ];

  // Psicología del color para el modo Branding (Nivel 2)
  static final List<Map<String, dynamic>> _psicologiaColor = [
    {
      "color": const Color(0xFF1E88E5), // Azul
      "name": "Azul Corporativo",
      "emocion": "alta confianza, seguridad institucional, estabilidad y lógica científica",
      "context": "TECNOLOGÍA Y SALUD"
    },
    {
      "color": const Color(0xFFE53935), // Rojo
      "name": "Rojo Impulsivo",
      "emocion": "activar el apetito inmediato de los consumidores de forma masiva y veloz",
      "context": "FAST FOOD Y EVENTOS"
    },
    {
      "color": const Color(0xFF43A047), // Verde
      "name": "Verde Orgánico",
      "emocion": "sustentabilidad, desarrollo orgánico y equilibrio natural de la vida",
      "context": "PRODUCTOS ECO Y BIENESTAR"
    },
    {
      "color": const Color(0xFF212121), // Negro
      "name": "Negro Premium",
      "emocion": "elegancia absoluta, sofisticación, solemnidad y alto estatus económico",
      "context": "LUJO EXCLUSIVO"
    },
    {
      "color": const Color(0xFFFFB300), // Amarillo
      "name": "Amarillo Optimismo",
      "emocion": "diversión pura, energía radiante, optimismo y estímulo mental temprano",
      "context": "INFANTIL Y JUGUETES"
    },
    {
      "color": const Color(0xFFEF6C00), // Naranja
      "name": "Naranja Innovación",
      "emocion": "innovación constante, juventud, diversión, dinamismo y factor de asombro",
      "context": "ESTUDIO CREATIVO O AGENCIA"
    },
    {
      "color": const Color(0xFF8E24AA), // Púrpura/Violeta
      "name": "Violeta Zen",
      "emocion": "relajación mental absoluta, equilibrio espiritual, transmutación y paz",
      "context": "SPA Y CENTRO DE MEDITACIÓN"
    },
    {
      "color": const Color(0xFF8B4513), // Café
      "name": "Café Tradición",
      "emocion": "tradición ancestral, conexión con las raíces, calidez rústica y durabilidad",
      "context": "HISTORIA Y ARQUEOLOGÍA"
    },
    {
      "color": const Color(0xFFE91E63), // Rosa
      "name": "Rosa Empatía",
      "emocion": "creatividad sin límites, dulzura, empatía profunda y calidez de cuidado",
      "context": "PROYECTO SOCIAL O JUGUETES"
    },
    {
      "color": const Color(0xFF00BEC4), // Turquesa
      "name": "Turquesa Vital",
      "emocion": "frescura higiénica, claridad mental, innovación limpia y tecnología médica",
      "context": "ODONTOLOGÍA Y SOFTWARE MÉDICO"
    },
    {
      "color": const Color(0xFFFFD166), // Dorado
      "name": "Dorado Éxito",
      "emocion": "éxito supremo, prosperidad económica, prestigio histórico y calidad artesanal",
      "context": "JOYERÍA DE LUJO Y LICORES PREMIUM"
    },
    {
      "color": const Color(0xFF78909C), // Gris
      "name": "Gris Profesional",
      "emocion": "neutralidad sobria, balance corporativo, objetividad moderna y minimalismo",
      "context": "ESTUDIO DE ARQUITECTURA Y MODA"
    }
  ];

  static final List<String> _plantillasBrief = [
    "El cliente exige proyectar {emocion}. ¿Qué matiz es el ideal?",
    "Se busca transmitir {emocion}. Selecciona el pigmento indicado para esta identidad visual:",
    "Diseño contemporáneo basado en {emocion}. ¿Cuál es su color base?",
    "Se requiere comunicar {emocion} sin distracciones de forma instantánea. Elige el tono idóneo:",
    "El brief de la marca pide denotar {emocion} para conectar con su audiencia. Elige:"
  ];

  static final List<String> _plantillasContrasteClaro = [
    "Un usuario con fatiga visual leerá este banner. Selecciona el color de texto más legible:",
    "Diseñas una tarjeta sobre este fondo claro. Elige el matiz que cumpla con el estándar de accesibilidad WCAG:",
    "Para la tipografía principal en este fondo luminoso, escoge el color con óptima relación de contraste:",
    "El cliente pide que este bloque claro resalte un botón importante. Elige el color del texto:"
  ];

  static final List<String> _plantillasContrasteOscuro = [
    "Un sitio web con modo nocturno utiliza este fondo oscuro. ¿Cuál color de texto ofrece la mejor lectura?",
    "Para un cartel publicitario digital sobre este fondo negro, selecciona la tipografía con mayor legibilidad:",
    "Accesibilidad en interfaces: Elige el color de texto que cumpla con el contraste mínimo sobre este fondo:",
    "Diseñas una alerta crítica en una pantalla oscura. Elige el pigmento idóneo para que resalte:"
  ];

  static final List<List<String>> _parejasTextoPreview = [
    ["ACCESIBILIDAD", "WCAG AAA"],
    ["DISEÑO WEB", "UX / UI"],
    ["MÁXIMO", "CONTRASTE"],
    ["TEXTO", "LEGIBLE"],
    ["INTERFAZ", "DIGITAL"],
    ["PIGMENTO", "ESTABLE"],
    ["BOTÓN CTA", "CLICK AQUÍ"],
    ["ALERTA", "IMPORTANTE"]
  ];

  /// Obtiene la configuración de un nivel según el número N
  static dynamic generarNivel(int nivel) {
    int tipo = nivel % 12; // Rotamos entre 12 tipos de niveles

    if (tipo == 1) {
      // Mezclas (Nivel 1)
      int idx = (nivel ~/ 4) % mezclasBase.length;
      final base = mezclasBase[idx];
      return MixLevelModel(
        level: nivel,
        objective: base["objective"],
        colorHex: base["colorHex"],
        instruction: base["instruction"],
        color1: base["c1"],
        color2: base["c2"],
      );
    } else if (tipo == 2) {
      // Buscar / Branding (Nivel 2)
      final random = math.Random(nivel * 97 + 13);
      final psic = _psicologiaColor[random.nextInt(_psicologiaColor.length)];
      final plantilla = _plantillasBrief[random.nextInt(_plantillasBrief.length)];
      final briefText = plantilla.replaceAll("{emocion}", psic["emocion"]);

      return SearchLevelModel(
        level: nivel,
        instruction: briefText,
        context: psic["context"],
        correctColor: psic["color"],
        colorName: psic["name"],
      );
    } else if (tipo == 3) {
      // Degradados (Nivel 3)
      final random = math.Random(nivel * 79 + 23);
      
      // Generación procedural de colores extremos en HSL
      double h1 = random.nextDouble() * 360;
      double h2 = (h1 + 60 + random.nextDouble() * 120) % 360; // 60 a 180 de diferencia
      double s = 0.65 + random.nextDouble() * 0.25; // 65% a 90%
      double l1 = 0.35 + random.nextDouble() * 0.15; // 35% a 50%
      double l2 = 0.55 + random.nextDouble() * 0.15; // 55% a 70%

      Color colorInicio = HSLColor.fromAHSL(1.0, h1, s, l1).toColor();
      Color colorFin = HSLColor.fromAHSL(1.0, h2, s, l2).toColor();

      int largoSecuencia = 4;
      if (nivel > 15) largoSecuencia = 5;
      if (nivel > 30) largoSecuencia = 6;

      List<Color> secuenciaCompleta = [];
      for (int i = 0; i < largoSecuencia; i++) {
        double t = i / (largoSecuencia - 1);
        Color colorPaso = Color.lerp(colorInicio, colorFin, t)!;
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
    } else if (tipo == 4) {
      // Contraste Cromático / Legibilidad (Nivel 4 / tipo == 4)
      final random = math.Random(nivel * 61 + 37);
      bool fondoClaro = random.nextBool();

      double h = random.nextDouble() * 360;
      double s = 0.5 + random.nextDouble() * 0.4;
      double l = fondoClaro ? 0.75 + random.nextDouble() * 0.15 : 0.1 + random.nextDouble() * 0.2;

      Color bgColor = HSLColor.fromAHSL(1.0, h, s, l).toColor();

      Color correctColor;
      List<Color> distractors = [];

      if (fondoClaro) {
        // Fondo claro: el texto correcto debe ser muy oscuro
        correctColor = HSLColor.fromAHSL(1.0, (h + 180) % 360, 0.4, 0.15).toColor();
        distractors.add(HSLColor.fromAHSL(1.0, h, s, l - 0.1).toColor()); // Muy parecido al fondo
        distractors.add(HSLColor.fromAHSL(1.0, (h + 30) % 360, s, 0.85).toColor()); // Claro
        distractors.add(Colors.white); // Blanco (legibilidad malísima sobre fondo claro)
      } else {
        // Fondo oscuro: el texto correcto debe ser muy claro
        correctColor = HSLColor.fromAHSL(1.0, h, 0.9, 0.85).toColor();
        distractors.add(HSLColor.fromAHSL(1.0, h, s, l + 0.1).toColor()); // Muy parecido al fondo
        distractors.add(HSLColor.fromAHSL(1.0, (h + 180) % 360, s, 0.2).toColor()); // Muy oscuro
        distractors.add(const Color(0xFF212121)); // Negro carbón
      }

      List<Color> options = [correctColor, ...distractors]..shuffle(random);

      // Asegurar que no haya duplicados idénticos en la lista de opciones
      options = options.toSet().toList();
      while (options.length < 4) {
        options.add(HSLColor.fromAHSL(1.0, (h + random.nextDouble() * 360) % 360, 0.5, fondoClaro ? 0.9 : 0.1).toColor());
        options = options.toSet().toList();
      }

      double l1 = correctColor.computeLuminance();
      double l2 = bgColor.computeLuminance();
      double ratio = (math.max(l1, l2) + 0.05) / (math.min(l1, l2) + 0.05);

      final plantilla = fondoClaro
          ? _plantillasContrasteClaro[random.nextInt(_plantillasContrasteClaro.length)]
          : _plantillasContrasteOscuro[random.nextInt(_plantillasContrasteOscuro.length)];

      final textoPareja = _parejasTextoPreview[random.nextInt(_parejasTextoPreview.length)];

      String explanation = "La opción correcta ofrece una relación de contraste de ${ratio.toStringAsFixed(1)}:1, garantizando una legibilidad óptima bajo pautas WCAG.";

      return ContrastLevelModel(
        level: nivel,
        instruction: plantilla,
        backgroundColor: bgColor,
        correctTextColor: correctColor,
        options: options,
        explanation: explanation,
        previewTextTop: textoPareja[0],
        previewTextBottom: textoPareja[1],
      );
    } else if (tipo == 5) {
      // Armonías Cromáticas (Nivel 5 / tipo == 5)
      final random = math.Random(nivel * 53 + 17);
      final basePsic = _psicologiaColor[random.nextInt(_psicologiaColor.length)];
      Color baseColor = basePsic["color"];
      String baseColorName = basePsic["name"];
      
      int harmTypeInt = random.nextInt(2);
      String harmonyType = harmTypeInt == 0 ? "Complementario" : "Análogo";
      
      Color correctColor;
      if (harmTypeInt == 0) {
        final HSLColor hsl = HSLColor.fromColor(baseColor);
        correctColor = hsl.withHue((hsl.hue + 180) % 360).toColor();
      } else {
        final HSLColor hsl = HSLColor.fromColor(baseColor);
        double shift = random.nextBool() ? 30.0 : -30.0;
        correctColor = hsl.withHue((hsl.hue + shift + 360) % 360).toColor();
      }
      
      List<Color> distractors = [];
      final HSLColor hslBase = HSLColor.fromColor(baseColor);
      distractors.add(hslBase.withLightness((hslBase.lightness > 0.5) ? hslBase.lightness - 0.35 : hslBase.lightness + 0.35).toColor());
      distractors.add(hslBase.withHue((hslBase.hue + 90) % 360).toColor());
      distractors.add(hslBase.withHue((hslBase.hue + 270) % 360).toColor());
      
      List<Color> options = [correctColor, ...distractors]..shuffle(random);
      
      String question = "Para el color base '$baseColorName', selecciona el pigmento que representa su ARMONÍA ${harmonyType.toUpperCase()}:";
      
      return HarmonyLevelModel(
        level: nivel,
        instruction: question,
        baseColor: baseColor,
        baseColorName: baseColorName,
        harmonyType: harmonyType,
        correctColor: correctColor,
        options: options,
      );
    } else if (tipo == 6) {
      // Daltonismo (Nivel 6 / tipo == 6)
      final random = math.Random(nivel * 47 + 19);
      
      final int combinedIndex = (nivel ~/ 12) % 9;
      final int blindTypeInt = combinedIndex % 3;
      final int configIndex = combinedIndex ~/ 3;

      String blindType;
      Color targetColor;
      Color correctColor;
      List<Color> options = [];
      String question;
      String explanation;

      if (blindTypeInt == 0) {
        blindType = "Protanopia";
        explanation = "Bajo Protanopia, los tonos rojos se ven oscurecidos y desaturados, confundiéndose con marrones y verdes. Los colores con longitudes de onda más cortas o muy contrastantes como el amarillo, blanco o azul conservan alta visibilidad.";
        
        if (configIndex == 0) {
          targetColor = const Color(0xFFE53935); // Rojo Cadmio
          correctColor = const Color(0xFFFFB300); // Amarillo Cromo
          options = [
            const Color(0xFFE53935),
            const Color(0xFF43A047),
            const Color(0xFF795548),
            const Color(0xFFFFB300),
          ];
          question = "Bajo simulación de PROTANOPIA (ceguera al rojo), selecciona el único color que conserva una visualización de alta visibilidad (Amarillo Cromo):";
        } else if (configIndex == 1) {
          targetColor = const Color(0xFFC62828); // Rojo Oscuro
          correctColor = const Color(0xFF0288D1); // Celeste
          options = [
            const Color(0xFFC62828),
            const Color(0xFFD84315),
            const Color(0xFF757575),
            const Color(0xFF0288D1),
          ];
          question = "Bajo simulación de PROTANOPIA (donde el rojo oscuro parece casi negro), selecciona el color de contraste más brillante y legible (Celeste):";
        } else {
          targetColor = const Color(0xFFC2185B); // Magenta
          correctColor = const Color(0xFFFFFFFF); // Blanco
          options = [
            const Color(0xFFC2185B),
            const Color(0xFF6A1B9A),
            const Color(0xFF558B2F),
            const Color(0xFFFFFFFF),
          ];
          question = "Bajo simulación de PROTANOPIA (que altera los tonos rojizos y violetas), selecciona la opción con mayor contraste acromático y claridad (Blanco):";
        }
      } else if (blindTypeInt == 1) {
        blindType = "Deuteranopia";
        explanation = "Bajo Deuteranopia, los tonos verdes pierden saturación y se confunden con rojos y violetas. Los colores amarillos o azules destacan con claridad.";

        if (configIndex == 0) {
          targetColor = const Color(0xFF43A047); // Verde Viridián
          correctColor = const Color(0xFFFFB300); // Amarillo Cromo
          options = [
            const Color(0xFF43A047),
            const Color(0xFFE53935),
            const Color(0xFF8E24AA),
            const Color(0xFFFFB300),
          ];
          question = "Bajo simulación de DEUTERANOPIA (ceguera al verde), selecciona el único color que conserva una visualización de alta visibilidad (Amarillo Cromo):";
        } else if (configIndex == 1) {
          targetColor = const Color(0xFF9E9D24); // Limón
          correctColor = const Color(0xFF1976D2); // Azul Rey
          options = [
            const Color(0xFF9E9D24),
            const Color(0xFFEF6C00),
            const Color(0xFF9E9E9E),
            const Color(0xFF1976D2),
          ];
          question = "Bajo simulación de DEUTERANOPIA (que dificulta distinguir verdes y marrones), selecciona la opción que destaca con un contraste nítido y frío (Azul Rey):";
        } else {
          targetColor = const Color(0xFF558B2F); // Verde Oliva
          correctColor = const Color(0xFFFF4081); // Rosado Neón
          options = [
            const Color(0xFF558B2F),
            const Color(0xFF4E342E),
            const Color(0xFFC62828),
            const Color(0xFFFF4081),
          ];
          question = "Bajo simulación de DEUTERANOPIA (donde el verde oliva y el café se solapan), selecciona el pigmento que destaca por su alta luminosidad (Rosado Neón):";
        }
      } else {
        blindType = "Tritanopia";
        explanation = "Bajo Tritanopia, se confunden los tonos azules con verdes y amarillos con violetas. Los tonos rojos y naranjas son los que mejor conservan su identidad y visibilidad.";

        if (configIndex == 0) {
          targetColor = const Color(0xFF1E88E5); // Azul Cobalto
          correctColor = const Color(0xFFE53935); // Rojo Cadmio
          options = [
            const Color(0xFF1E88E5),
            const Color(0xFF00BEC4),
            const Color(0xFF43A047),
            const Color(0xFFE53935),
          ];
          question = "Bajo simulación de TRITANOPIA (ceguera al azul), selecciona el color de contraste más vivo y visible en la pantalla (Rojo Cadmio):";
        } else if (configIndex == 1) {
          targetColor = const Color(0xFFFFD54F); // Amarillo Claro
          correctColor = const Color(0xFF4A148C); // Púrpura Oscuro
          options = [
            const Color(0xFFFFD54F),
            const Color(0xFFFFB74D),
            const Color(0xFFF8BBD0),
            const Color(0xFF4A148C),
          ];
          question = "Bajo simulación de TRITANOPIA (donde el amarillo y el rosa se fusionan), selecciona el color frío que mantiene un excelente nivel de legibilidad (Púrpura Oscuro):";
        } else {
          targetColor = const Color(0xFF00ACC1); // Turquesa
          correctColor = const Color(0xFFF4511E); // Rojo Naranja
          options = [
            const Color(0xFF00ACC1),
            const Color(0xFF4FC3F7),
            const Color(0xFF4CAF50),
            const Color(0xFFF4511E),
          ];
          question = "Bajo simulación de TRITANOPIA (que mezcla los cianes, verdes y azules), selecciona el color cálido óptimo para alertar al usuario (Rojo Naranja):";
        }
      }

      options.shuffle(random);
      
      return BlindLevelModel(
        level: nivel,
        instruction: question,
        targetColor: targetColor,
        blindType: blindType,
        correctColor: correctColor,
        options: options,
        explanation: explanation,
      );
    } else if (tipo == 7) {
      // Laboratorio RGB (Nivel 7 / tipo == 7)
      final random = math.Random(nivel * 41 + 29);
      final basePsic = _psicologiaColor[random.nextInt(_psicologiaColor.length)];
      
      String question = "Ajusta los deslizadores de Rojo, Verde y Azul para aproximarte al color objetivo de laboratorio:";
      
      return RgbLevelModel(
        level: nivel,
        instruction: question,
        targetColor: basePsic["color"],
        targetColorName: basePsic["name"],
      );
    } else if (tipo == 8) {
      // Temperatura del Color (Nivel 8 / tipo == 8)
      final random = math.Random(nivel * 31 + 43);
      final List<Color> warmPool = [
        const Color(0xFFE53935), 
        const Color(0xFFFFB300), 
        const Color(0xFFEF6C00), 
        const Color(0xFFFF70A6), 
      ];
      final List<Color> coldPool = [
        const Color(0xFF1E88E5), 
        const Color(0xFF43A047), 
        const Color(0xFF00BEC4), 
        const Color(0xFF8E24AA), 
      ];
      
      List<Color> warmColors = List.from(warmPool)..shuffle(random);
      warmColors = warmColors.sublist(0, 2);
      
      List<Color> coldColors = List.from(coldPool)..shuffle(random);
      coldColors = coldColors.sublist(0, 2);
      
      List<Color> allOptions = [...warmColors, ...coldColors]..shuffle(random);
      
      String question = "Clasifica los pigmentos de laboratorio arrastrándolos a los frascos receptores correctos según su temperatura visual:";
      
      return TempLevelModel(
        level: nivel,
        instruction: question,
        warmColors: warmColors,
        coldColors: coldColors,
        allOptions: allOptions,
      );
    } else if (tipo == 9) {
      // Código HEX (Nivel 9 / tipo == 9)
      final random = math.Random(nivel * 43 + 31);
      final psic = _psicologiaColor[random.nextInt(_psicologiaColor.length)];
      final Color correctColor = psic["color"];
      final String hexCode = "#${correctColor.value.toRadixString(16).substring(2).toUpperCase()}";
      
      List<Color> distractors = [];
      while (distractors.length < 3) {
        final Color c = _psicologiaColor[random.nextInt(_psicologiaColor.length)]["color"];
        if (c.value != correctColor.value && !distractors.contains(c)) {
          distractors.add(c);
        }
      }
      
      List<Color> options = [correctColor, ...distractors]..shuffle(random);
      
      String question = "Examina el código hexadecimal del laboratorio. ¿A cuál de los siguientes pigmentos corresponde?";
      
      return HexLevelModel(
        level: nivel,
        instruction: question,
        hexCode: hexCode,
        correctColor: correctColor,
        options: options,
      );
    } else if (tipo == 10) {
      // Ilusión Óptica (Nivel 10 / tipo == 10)
      final random = math.Random(nivel * 37 + 47);
      
      // 4 Setups de Josef Albers (Fondo Izq, Fondo Der, Color Núcleo Real, Distractores)
      final List<Map<String, dynamic>> setups = [
        {
          "leftBg": const Color(0xFF1E88E5), // Azul
          "rightBg": const Color(0xFFFFB300), // Amarillo
          "inner": const Color(0xFF8E8E83), // Gris
          "options": [
            const Color(0xFF8E8E83),
            const Color(0xFF8E8E9E), 
            const Color(0xFF9E8E83), 
            const Color(0xFF8E9E83), 
          ]
        },
        {
          "leftBg": const Color(0xFFE53935), // Rojo
          "rightBg": const Color(0xFF43A047), // Verde
          "inner": const Color(0xFFC58E59), // Ocre
          "options": [
            const Color(0xFFC58E59),
            const Color(0xFFC59E59), 
            const Color(0xFFB58E59), 
            const Color(0xFFC58E69), 
          ]
        },
        {
          "leftBg": const Color(0xFF8E24AA), // Púrpura
          "rightBg": const Color(0xFFEF6C00), // Naranja
          "inner": const Color(0xFFD87D9A), // Rosa sucio
          "options": [
            const Color(0xFFD87D9A),
            const Color(0xFFC87D9A), 
            const Color(0xFFD88D9A), 
            const Color(0xFFD87DAA), 
          ]
        },
        {
          "leftBg": const Color(0xFF0D47A1), // Azul Oscuro
          "rightBg": const Color(0xFF00E5FF), // Cian
          "inner": const Color(0xFF5C8E9D), // Pizarra
          "options": [
            const Color(0xFF5C8E9D),
            const Color(0xFF4C8E9D), 
            const Color(0xFF5C9E9D), 
            const Color(0xFF5C8EAD), 
          ]
        }
      ];

      final int setupIndex = (nivel ~/ 12) % setups.length;
      final setup = setups[setupIndex];

      final Color leftBg = setup["leftBg"];
      final Color rightBg = setup["rightBg"];
      final Color correctInner = setup["inner"];
      
      List<Color> options = List<Color>.from(setup["options"])..shuffle(random);
      
      String question = "Teoría del Contraste Simultáneo: Debido al fondo contrastante, el núcleo parece cambiar. Selecciona el pigmento real del núcleo:";
      String explanation = "Dos colores idénticos se perciben de forma diferente dependiendo del fondo sobre el que se encuentren (Teoría de Josef Albers). El núcleo en ambos lados es idéntico.";
      
      return AlbersLevelModel(
        level: nivel,
        instruction: question,
        leftBgColor: leftBg,
        rightBgColor: rightBg,
        correctInnerColor: correctInner,
        options: options,
        explanation: explanation,
      );
    } else if (tipo == 11) {
      // Atmósferas (Nivel 11 / tipo == 11)
      final random = math.Random(nivel * 29 + 61);
      final List<Map<String, dynamic>> conceptos = [
        {
          "name": "CYBERPUNK NEÓN",
          "correct": [const Color(0xFFFF0055), const Color(0xFF00FFCC), const Color(0xFF9900FF), const Color(0xFF001133), const Color(0xFFFFFFFF)],
          "wrong1": [const Color(0xFF8B4513), const Color(0xFFD2B48C), const Color(0xFFF5F5DC), const Color(0xFFFFF8E1), const Color(0xFFE5D3B3)],
          "wrong2": [const Color(0xFF43A047), const Color(0xFF2E7D32), const Color(0xFF1B5E20), const Color(0xFFC8E6C9), const Color(0xFFE8F5E9)],
          "wrong3": [const Color(0xFFE53935), const Color(0xFFD81B60), const Color(0xFF8E24AA), const Color(0xFFD32F2F), const Color(0xFFFFCDD2)]
        },
        {
          "name": "BOSQUE DE OTOÑO",
          "correct": [const Color(0xFFD35400), const Color(0xFFE67E22), const Color(0xFFF39C12), const Color(0xFF8B4513), const Color(0xFF2C3E50)],
          "wrong1": [const Color(0xFFFF0055), const Color(0xFF00FFCC), const Color(0xFF9900FF), const Color(0xFF001133), const Color(0xFFFFFFFF)],
          "wrong2": [const Color(0xFF008B8B), const Color(0xFF00FFFF), const Color(0xFFE0FFFF), const Color(0xFF00D8D8), const Color(0xFF004D4D)],
          "wrong3": [const Color(0xFF212121), const Color(0xFF424242), const Color(0xFF616161), const Color(0xFF9E9E9E), const Color(0xFFE0E0E0)]
        },
        {
          "name": "ATARDECER COSTERO",
          "correct": [const Color(0xFFFF70A6), const Color(0xFFFF9770), const Color(0xFFFFD670), const Color(0xFFE9FF70), const Color(0xFF70D6FF)],
          "wrong1": [const Color(0xFF3E2723), const Color(0xFF4E342E), const Color(0xFF5D4037), const Color(0xFF6D4C41), const Color(0xFF7E57C2)],
          "wrong2": [const Color(0xFF1B5E20), const Color(0xFF2E7D32), const Color(0xFF388E3C), const Color(0xFF4CAF50), const Color(0xFF81C784)],
          "wrong3": [const Color(0xFF0D47A1), const Color(0xFF1565C0), const Color(0xFF1976D2), const Color(0xFF1E88E5), const Color(0xFF2196F3)]
        },
        {
          "name": "NOCTURNO DE NEÓN",
          "correct": [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364), const Color(0xFF00FF87), const Color(0xFF60EFFF)],
          "wrong1": [const Color(0xFFFFB300), const Color(0xFFFFD54F), const Color(0xFFFFE082), const Color(0xFFFFF9C4), const Color(0xFFFFFDE7)],
          "wrong2": [const Color(0xFF8B4513), const Color(0xFFA0522D), const Color(0xFFCD853F), const Color(0xFFDEB887), const Color(0xFFF5F5DC)],
          "wrong3": [const Color(0xFFE53935), const Color(0xFFD81B60), const Color(0xFF8E24AA), const Color(0xFFC2185B), const Color(0xFFE91E63)]
        },
        {
          "name": "CIBER-ESPACIO RETRO",
          "correct": [const Color(0xFF00F5D4), const Color(0xFF7B2CBF), const Color(0xFF9D4EDD), const Color(0xFFE0AAFF), const Color(0xFFF15BB5)],
          "wrong1": [const Color(0xFF2E7D32), const Color(0xFF388E3C), const Color(0xFF4CAF50), const Color(0xFF66BB6A), const Color(0xFF81C784)],
          "wrong2": [const Color(0xFF3E2723), const Color(0xFF4E342E), const Color(0xFF5D4037), const Color(0xFF6D4C41), const Color(0xFF7E57C2)],
          "wrong3": [const Color(0xFFD84315), const Color(0xFFE64A19), const Color(0xFFF4511E), const Color(0xFFFF5722), const Color(0xFFFF7043)]
        },
        {
          "name": "MINERAL SUBTERRÁNEO",
          "correct": [const Color(0xFF37474F), const Color(0xFF455A64), const Color(0xFF00E676), const Color(0xFF00B0FF), const Color(0xFF90A4AE)],
          "wrong1": [const Color(0xFFF8BBD0), const Color(0xFFF48FB1), const Color(0xFFF06292), const Color(0xFFEC407A), const Color(0xFFE91E63)],
          "wrong2": [const Color(0xFFFFD54F), const Color(0xFFFFCA28), const Color(0xFFFFB300), const Color(0xFFFF8F00), const Color(0xFFFF6F00)],
          "wrong3": [const Color(0xFF6D4C41), const Color(0xFF5D4037), const Color(0xFF4E342E), const Color(0xFF3E2723), const Color(0xFF271B15)]
        }
      ];
      
      final int conceptoIndex = (nivel ~/ 12) % conceptos.length;
      final concepto = conceptos[conceptoIndex];
      final String conceptName = concepto["name"];
      final List<Color> correctPalette = concepto["correct"];
      
      List<List<Color>> optionPalettes = [
        concepto["correct"],
        concepto["wrong1"],
        concepto["wrong2"],
        concepto["wrong3"]
      ]..shuffle(random);
      
      String question = "El director de arte solicita una paleta que transmita la atmósfera de '$conceptName'. Elige la opción idónea:";
      
      return AtmosphereLevelModel(
        level: nivel,
        instruction: question,
        conceptName: conceptName,
        correctPalette: correctPalette,
        optionPalettes: optionPalettes,
      );
    } else {
      // Orden de Saturación (Nivel 12 / tipo == 0)
      final random = math.Random(nivel * 23 + 67);
      final psic = _psicologiaColor[random.nextInt(_psicologiaColor.length)];
      final Color baseColor = psic["color"];
      final HSLColor hsl = HSLColor.fromColor(baseColor);
      
      List<Color> sequence = [
        hsl.withSaturation(0.15).toColor(),
        hsl.withSaturation(0.40).toColor(),
        hsl.withSaturation(0.65).toColor(),
        hsl.withSaturation(0.95).toColor(),
      ];
      
      List<Color> shuffled = List<Color>.from(sequence)..shuffle(random);
      
      String question = "Ordenamiento Tonal: Selecciona los pigmentos en orden secuencial estricto, desde el más DESATURADO (grisáceo) al más SATURADO (puro):";
      
      return SaturationLevelModel(
        level: nivel,
        instruction: question,
        baseColor: baseColor,
        sequence: sequence,
        shuffled: shuffled,
      );
    }
  }

  /// Obtiene un dato curioso educativo contextualizado según el tipo de nivel
  static String obtenerDatoCurioso(dynamic model) {
    if (model is MixLevelModel) {
      return "Mezclar pigmentos físicos es una síntesis sustractiva: cada reactivo que añades absorbe más luz, por lo que el color final se vuelve más oscuro.";
    }
    if (model is SearchLevelModel) {
      final String emotion = model.instruction.contains("transmita")
          ? model.instruction.split("transmita").last.replaceAll(":", "").trim()
          : "emociones";
      return "El tono '${model.colorName}' se asocia con '$emotion'. En publicidad y diseño de marcas, los colores estimulan áreas cerebrales que influyen en las compras.";
    }
    if (model is GradientLevelModel) {
      return "Las transiciones en HSL son preferidas por diseñadores porque representan cómo la luz incide sobre un objeto: el tono (H) gira en el círculo y la luminosidad (L) añade brillo.";
    }
    if (model is ContrastLevelModel) {
      return "Para cumplir con la accesibilidad WCAG nivel AA, el contraste mínimo del texto pequeño debe ser de al menos 4.5:1. Los textos grandes o botones requieren un mínimo de 3:1.";
    }
    if (model is HarmonyLevelModel) {
      return "El esquema '${model.harmonyType}' utiliza la relación geométrica del círculo cromático. Los complementarios se colocan opuestos porque crean la mayor vibración visual.";
    }
    if (model is BlindLevelModel) {
      return "Bajo la condición de ${model.blindType}, ciertos fotoreceptores del ojo no funcionan correctamente. Por eso, usar amarillo o azul para alertas clave es una buena práctica de accesibilidad.";
    }
    if (model is RgbLevelModel) {
      return "El modelo RGB es aditivo: mezcla luces directamente en la pantalla de tu móvil. Al sumar el máximo de Rojo, Verde y Azul (255, 255, 255) obtienes luz blanca pura.";
    }
    if (model is TempLevelModel) {
      return "La temperatura del color (cálido vs frío) influye en el ritmo cardíaco y la percepción del espacio: los tonos cálidos hacen que los objetos parezcan más cercanos.";
    }
    if (model is HexLevelModel) {
      return "Los códigos HEX definen la mezcla RGB en formato base 16 (hexadecimal): los dígitos 00-FF representan la cantidad de Rojo, Verde y Azul respectivamente.";
    }
    if (model is AlbersLevelModel) {
      return "El pintor Josef Albers demostró en 1963 la relatividad del color: un mismo color físico se percibe como dos tonos completamente distintos dependiendo de su fondo.";
    }
    if (model is AtmosphereLevelModel) {
      return "En el cine, directores como Wes Anderson utilizan paletas de color con un concepto dominante para definir la época, emoción o personalidad de un personaje.";
    }
    if (model is SaturationLevelModel) {
      return "La saturación es la pureza del color. Un color al 0% de saturación se convierte en un tono de gris neutro, mientras que al 100% es el pigmento más vivo posible.";
    }
    return "El estudio científico del color une la física de la luz, la química de los pigmentos y la biología de nuestros ojos.";
  }
}
