import 'package:flutter/material.dart';
import '../../../controllers/nivel9_controller.dart';
import '../../../models/level_model.dart';
import '../../widgets/game_button.dart';
import 'base_gameplay_screen.dart';

class Nivel9Screen extends StatelessWidget {
  final int nivelInicial;

  const Nivel9Screen({super.key, required this.nivelInicial});

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
    return BaseGameplayScreen<HexLevelModel, Nivel9Controller>(
      nivel: nivelInicial,
      controllerFactory: (context) => Nivel9Controller(nivelInicial: nivelInicial),
      gameFieldBuilder: (context, controller) {
        final datosNivel = controller.datosNivel;

        return Column(
          children: [
            // HEX CODE DISPLAY CARD
            const Text(
              "CÓDIGO HEXADECIMAL DEL REACTIVO:",
              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF131720),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFF9F1C).withOpacity(0.3), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF9F1C).withOpacity(0.15),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Text(
                datosNivel.hexCode,
                style: const TextStyle(
                  color: Color(0xFFFF9F1C),
                  fontSize: 32,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 48),
            const Text(
              "PIGMENTOS DE LABORATORIO DISPONIBLES:",
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
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.science_outlined,
                        color: Colors.white60,
                        size: 28,
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
