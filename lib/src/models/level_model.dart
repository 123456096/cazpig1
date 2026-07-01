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

  ContrastLevelModel({
    required super.level,
    required super.instruction, // maps to question
    required this.backgroundColor,
    required this.correctTextColor,
    required this.options,
    required this.explanation,
  }) : super(title: "Contraste");
}
