import 'package:flutter/material.dart';

abstract class LevelModel {
  final int level;
  final String title;
  final String instruction;

  LevelModel({
    required this.level,
    required this.title,
    required this.instruction,
  });
}

class MixLevelModel extends LevelModel {
  final String objective;
  final Color colorHex;
  final Color color1;
  final Color color2;

  MixLevelModel({
    required super.level,
    required super.instruction,
    required this.objective,
    required this.colorHex,
    required this.color1,
    required this.color2,
  }) : super(title: "Mezclas");
}

class SearchLevelModel extends LevelModel {
  final String context;
  final Color correctColor;
  final String colorName;

  SearchLevelModel({
    required super.level,
    required super.instruction, // maps to brief
    required this.context,
    required this.correctColor,
    required this.colorName,
  }) : super(title: "Branding");
}

class GradientLevelModel extends LevelModel {
  final List<Color> sequence;
  final Color correctColor;
  final String colorName;

  GradientLevelModel({
    required super.level,
    required this.sequence,
    required this.correctColor,
    required this.colorName,
  }) : super(
          title: "Degradados",
          instruction: "Identifica cuál de las opciones completa la escala cromática sin romper el degradado.",
        );
}

class ContrastLevelModel extends LevelModel {
  final Color backgroundColor;
  final Color correctTextColor;
  final List<Color> options;
  final String explanation;
  final String previewTextTop;
  final String previewTextBottom;

  ContrastLevelModel({
    required super.level,
    required super.instruction, 
    required this.backgroundColor,
    required this.correctTextColor,
    required this.options,
    required this.explanation,
    required this.previewTextTop,
    required this.previewTextBottom,
  }) : super(title: "Contraste");
}

class HarmonyLevelModel extends LevelModel {
  final Color baseColor;
  final String baseColorName;
  final String harmonyType; 
  final Color correctColor;
  final List<Color> options;

  HarmonyLevelModel({
    required super.level,
    required super.instruction,
    required this.baseColor,
    required this.baseColorName,
    required this.harmonyType,
    required this.correctColor,
    required this.options,
  }) : super(title: "Armonía");
}

class BlindLevelModel extends LevelModel {
  final Color targetColor;
  final String blindType; 
  final Color correctColor;
  final List<Color> options;
  final String explanation;

  BlindLevelModel({
    required super.level,
    required super.instruction,
    required this.targetColor,
    required this.blindType,
    required this.correctColor,
    required this.options,
    required this.explanation,
  }) : super(title: "Daltonismo");
}

class RgbLevelModel extends LevelModel {
  final Color targetColor;
  final String targetColorName;

  RgbLevelModel({
    required super.level,
    required super.instruction,
    required this.targetColor,
    required this.targetColorName,
  }) : super(title: "Laboratorio RGB");
}

class TempLevelModel extends LevelModel {
  final List<Color> warmColors;
  final List<Color> coldColors;
  final List<Color> allOptions;

  TempLevelModel({
    required super.level,
    required super.instruction,
    required this.warmColors,
    required this.coldColors,
    required this.allOptions,
  }) : super(title: "Temperatura");
}

class HexLevelModel extends LevelModel {
  final String hexCode;
  final Color correctColor;
  final List<Color> options;

  HexLevelModel({
    required super.level,
    required super.instruction,
    required this.hexCode,
    required this.correctColor,
    required this.options,
  }) : super(title: "Adivina el HEX");
}

class AlbersLevelModel extends LevelModel {
  final Color leftBgColor;
  final Color rightBgColor;
  final Color correctInnerColor;
  final List<Color> options;
  final String explanation;

  AlbersLevelModel({
    required super.level,
    required super.instruction,
    required this.leftBgColor,
    required this.rightBgColor,
    required this.correctInnerColor,
    required this.options,
    required this.explanation,
  }) : super(title: "Ilusión Óptica");
}

class AtmosphereLevelModel extends LevelModel {
  final String conceptName;
  final List<Color> correctPalette;
  final List<List<Color>> optionPalettes;

  AtmosphereLevelModel({
    required super.level,
    required super.instruction,
    required this.conceptName,
    required this.correctPalette,
    required this.optionPalettes,
  }) : super(title: "Atmósferas");
}

class SaturationLevelModel extends LevelModel {
  final Color baseColor;
  final List<Color> sequence;
  final List<Color> shuffled;

  SaturationLevelModel({
    required super.level,
    required super.instruction,
    required this.baseColor,
    required this.sequence,
    required this.shuffled,
  }) : super(title: "Saturación");
}
