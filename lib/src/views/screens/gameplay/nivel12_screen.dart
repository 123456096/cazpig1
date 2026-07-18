import 'package:flutter/material.dart';
import '../../../controllers/nivel12_controller.dart';
import '../../../models/level_model.dart';
import '../../widgets/game_button.dart';
import 'base_gameplay_screen.dart';

class Nivel12Screen extends StatelessWidget {
  final int nivelInicial;

  const Nivel12Screen({super.key, required this.nivelInicial});

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
    return BaseGameplayScreen<SaturationLevelModel, Nivel12Controller>(
      nivel: nivelInicial,
      controllerFactory: (context) => Nivel12Controller(nivelInicial: nivelInicial),
      gameFieldBuilder: (context, controller) {
        final datosNivel = controller.datosNivel;

        return Column(
          children: [
            // SECUENCIA RESULTADO (ORDEN CREADO)
            const Text(
              "SECUENCIA DE ORDENAMIENTO (De desaturado a saturado):",
              style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(datosNivel.sequence.length, (idx) {
                final Color? color = idx < controller.seleccion.length ? controller.seleccion[idx] : null;

                return GestureDetector(
                  onTap: () {
                    if (color != null) {
                      controller.toggleColor(color);
                    }
                  },
                  child: Container(
                    width: 65,
                    height: 65,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: color ?? const Color(0xFF141824),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: color != null ? const Color(0xFFFF9F1C) : const Color(0xFF2C3446),
                        width: color != null ? 2.5 : 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: color == null
                        ? Text(
                            "${idx + 1}",
                            style: const TextStyle(color: Colors.white24, fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        : const SizedBox.shrink(),
                  ),
                );
              }),
            ),
            const SizedBox(height: 48),
            // OPCIONES DISPONIBLES
            const Text(
              "PIGMENTOS DESORDENADOS EN LA MESA:",
              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: datosNivel.shuffled.map((color) {
                final bool seleccionado = controller.seleccion.contains(color);

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: seleccionado ? Colors.transparent : Colors.transparent,
                      width: 3.5,
                    ),
                  ),
                  child: Opacity(
                    opacity: seleccionado ? 0.35 : 1.0,
                    child: GameButton(
                      width: 70,
                      height: 70,
                      borderRadius: 18,
                      backgroundColor: color,
                      shadowColor: _getShadowColor(color),
                      onTap: () => controller.toggleColor(color),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "#${color.value.toRadixString(16).substring(2).toUpperCase()}",
                            style: const TextStyle(color: Colors.white, fontSize: 8, fontFamily: 'monospace'),
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
