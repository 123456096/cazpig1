import 'package:flutter/material.dart';
import '../../../controllers/nivel3_controller.dart';
import '../../../models/level_model.dart';
import '../../widgets/game_button.dart';
import 'base_gameplay_screen.dart';

class Nivel3Screen extends StatelessWidget {
  final int nivelInicial;

  const Nivel3Screen({super.key, required this.nivelInicial});

  Color _getShadowColor(Color color) {
    return Color.fromARGB(
      (color.a * 255.0).round().clamp(0, 255),
      (color.r * 255.0 * 0.7).round().clamp(0, 255),
      (color.g * 255.0 * 0.7).round().clamp(0, 255),
      (color.b * 255.0 * 0.7).round().clamp(0, 255),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double ancho = MediaQuery.of(context).size.width;

    return BaseGameplayScreen<GradientLevelModel, Nivel3Controller>(
      nivel: nivelInicial,
      controllerFactory: (context) => Nivel3Controller(nivelInicial: nivelInicial),
      gameFieldBuilder: (context, controller) {
        final datosNivel = controller.datosNivel;

        // Generar la secuencia con previsualización del color seleccionado
        List<Widget> secuenciaWidgets = datosNivel.sequence.map((color) {
          if (color.value == Colors.transparent.value) {
            final Color? previewColor = controller.colorSeleccionado;
            return Container(
              width: ancho > 600 ? 90 : 65,
              height: 70,
              decoration: BoxDecoration(
                color: previewColor ?? const Color(0xFF141824),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: previewColor != null ? const Color(0xFFFF9F1C) : const Color(0xFF9B5DE5),
                  width: 2.5,
                ),
              ),
              child: previewColor == null
                  ? const Icon(
                      Icons.help_outline_rounded,
                      color: Color(0xFF9B5DE5),
                      size: 32,
                    )
                  : const SizedBox.shrink(),
            );
          }

          return Container(
            width: ancho > 600 ? 90 : 65,
            height: 70,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        }).toList();

        return Column(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: secuenciaWidgets,
            ),
            const SizedBox(height: 50),
            const Text(
              "SELECCIONA EL TONO DE REEMPLAZO CORRECTO:",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Opciones del degradado como botones 3D
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: controller.opcionesMuestras.map((opcion) {
                final Color optionColor = opcion["color"];
                final bool seleccionado = controller.colorSeleccionado == optionColor;

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: seleccionado ? const Color(0xFFFF9F1C) : Colors.transparent,
                      width: 3.5,
                    ),
                  ),
                  child: GameButton(
                    width: 70,
                    height: 70,
                    borderRadius: 20,
                    backgroundColor: optionColor,
                    shadowColor: _getShadowColor(optionColor),
                    onTap: () => controller.seleccionarColor(optionColor),
                    child: const SizedBox.shrink(),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
