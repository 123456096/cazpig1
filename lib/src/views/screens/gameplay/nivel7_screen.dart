import 'package:flutter/material.dart';
import '../../../controllers/nivel7_controller.dart';
import '../../../models/level_model.dart';
import 'base_gameplay_screen.dart';

class Nivel7Screen extends StatelessWidget {
  final int nivelInicial;

  const Nivel7Screen({super.key, required this.nivelInicial});

  @override
  Widget build(BuildContext context) {
    return BaseGameplayScreen<RgbLevelModel, Nivel7Controller>(
      nivel: nivelInicial,
      controllerFactory: (context) => Nivel7Controller(nivelInicial: nivelInicial),
      gameFieldBuilder: (context, controller) {
        final datosNivel = controller.datosNivel;
        final Color current = controller.currentColor;

        return Column(
          children: [
            // MATRACES DE COMPARACIÓN
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // MATRAZ OBJETIVO
                Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: datosNivel.targetColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: datosNivel.targetColor.withOpacity(0.55),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.science, color: Colors.white70, size: 36),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      datosNivel.targetColorName,
                      style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "#${datosNivel.targetColor.value.toRadixString(16).substring(2).toUpperCase()}",
                      style: const TextStyle(color: Colors.white54, fontSize: 10, fontFamily: 'monospace'),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.compare_arrows_rounded, color: Colors.white30, size: 32),
                ),
                // MATRAZ ACTUAL
                Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: current,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFFF9F1C), width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: current.withOpacity(0.55),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.science_outlined, color: Colors.white70, size: 36),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Tu Mezcla",
                      style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "#${current.value.toRadixString(16).substring(2).toUpperCase()}",
                      style: const TextStyle(color: Color(0xFFFF9F1C), fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // INDICADOR DE COINCIDENCIA / SIMILITUD
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: controller.similarity >= 87 ? Colors.greenAccent.withValues(alpha: 0.3) : Colors.white10,
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "Similitud: ${controller.similarity.toStringAsFixed(0)}%",
                    style: TextStyle(
                      color: controller.similarity >= 87 ? Colors.greenAccent : const Color(0xFFFF9F1C),
                      fontSize: 16,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    controller.feedbackMessage,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // CONTROLES DESLIZADORES
            _buildSliderRow(
              context: context,
              label: "ROJO (R)",
              value: controller.r,
              color: Colors.redAccent,
              onChanged: (val) => controller.updateRed(val),
            ),
            const SizedBox(height: 16),
            _buildSliderRow(
              context: context,
              label: "VERDE (G)",
              value: controller.g,
              color: Colors.greenAccent,
              onChanged: (val) => controller.updateGreen(val),
            ),
            const SizedBox(height: 16),
            _buildSliderRow(
              context: context,
              label: "AZUL (B)",
              value: controller.b,
              color: Colors.blueAccent,
              onChanged: (val) => controller.updateBlue(val),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSliderRow({
    required BuildContext context,
    required String label,
    required double value,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.5),
              ),
              Text(
                value.toInt().toString(),
                style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Slider(
          value: value,
          min: 0.0,
          max: 255.0,
          divisions: 15,
          activeColor: color,
          inactiveColor: Colors.grey.shade800,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
