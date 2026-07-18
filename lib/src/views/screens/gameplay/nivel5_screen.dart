import 'package:flutter/material.dart';
import '../../../controllers/nivel5_controller.dart';
import '../../../models/level_model.dart';
import '../../widgets/game_button.dart';
import 'base_gameplay_screen.dart';

class Nivel5Screen extends StatelessWidget {
  final int nivelInicial;

  const Nivel5Screen({super.key, required this.nivelInicial});

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
    return BaseGameplayScreen<HarmonyLevelModel, Nivel5Controller>(
      nivel: nivelInicial,
      controllerFactory: (context) => Nivel5Controller(nivelInicial: nivelInicial),
      gameFieldBuilder: (context, controller) {
        final datosNivel = controller.datosNivel;

        return Column(
          children: [
            // CÍRCULO DEL COLOR BASE
            const Text(
              "COLOR BASE OBJETIVO:",
              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: datosNivel.baseColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.15), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: datosNivel.baseColor.withOpacity(0.55),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "#${datosNivel.baseColor.value.toRadixString(16).substring(2).toUpperCase()}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              datosNivel.baseColorName,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            const Text(
              "OPCIONES DE ARMONÍA:",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
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
