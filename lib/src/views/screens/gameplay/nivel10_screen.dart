import 'package:flutter/material.dart';
import '../../../controllers/nivel10_controller.dart';
import '../../../models/level_model.dart';
import '../../widgets/game_button.dart';
import 'base_gameplay_screen.dart';

class Nivel10Screen extends StatelessWidget {
  final int nivelInicial;

  const Nivel10Screen({super.key, required this.nivelInicial});

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
    return BaseGameplayScreen<AlbersLevelModel, Nivel10Controller>(
      nivel: nivelInicial,
      controllerFactory: (context) => Nivel10Controller(nivelInicial: nivelInicial),
      gameFieldBuilder: (context, controller) {
        final datosNivel = controller.datosNivel;
        final Color previewInner = controller.colorSeleccionado ?? Colors.transparent;

        return Column(
          children: [
            // ÁREA DE LA ILUSIÓN (DOS FONDOS CONTRASTANTES)
            Row(
              children: [
                // PANEL IZQUIERDO
                Expanded(
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: datosNivel.leftBgColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        bottomLeft: Radius.circular(24),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: previewInner,
                        borderRadius: BorderRadius.circular(4),
                        border: previewInner == Colors.transparent
                            ? Border.all(color: Colors.white60, width: 2, style: BorderStyle.solid)
                            : null,
                      ),
                      child: previewInner == Colors.transparent
                          ? const Icon(Icons.help_outline, color: Colors.white60, size: 20)
                          : null,
                    ),
                  ),
                ),
                // PANEL DERECHO
                Expanded(
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: datosNivel.rightBgColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: previewInner,
                        borderRadius: BorderRadius.circular(4),
                        border: previewInner == Colors.transparent
                            ? Border.all(color: Colors.black45, width: 2, style: BorderStyle.solid)
                            : null,
                      ),
                      child: previewInner == Colors.transparent
                          ? const Icon(Icons.help_outline, color: Colors.black45, size: 20)
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              "¿Es el mismo color central? Compruébalo con las muestras:",
              style: TextStyle(color: Colors.white54, fontSize: 11, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 36),
            const Text(
              "SELECCIONA EL REACTIVO PARA COMPARAR:",
              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: datosNivel.options.map((color) {
                final bool seleccionado = controller.colorSeleccionado == color;

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: seleccionado ? const Color(0xFFFF9F1C) : Colors.transparent,
                      width: 3.5,
                    ),
                  ),
                  child: GameButton(
                    width: 75,
                    height: 75,
                    borderRadius: 20,
                    backgroundColor: color,
                    shadowColor: _getShadowColor(color),
                    onTap: () => controller.seleccionarColor(color),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "#${color.value.toRadixString(16).substring(2).toUpperCase()}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
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
