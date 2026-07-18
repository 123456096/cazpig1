import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../controllers/nivel4_controller.dart';
import '../../../models/level_model.dart';
import '../../widgets/game_button.dart';
import 'base_gameplay_screen.dart';

class Nivel4Screen extends StatelessWidget {
  final int nivelInicial;

  const Nivel4Screen({super.key, required this.nivelInicial});

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
    return BaseGameplayScreen<ContrastLevelModel, Nivel4Controller>(
      nivel: nivelInicial,
      controllerFactory: (context) => Nivel4Controller(nivelInicial: nivelInicial),
      gameFieldBuilder: (context, controller) {
        final datosNivel = controller.datosNivel;
        final Color? selected = controller.colorSeleccionado;
        double? currentRatio;
        if (selected != null) {
          final double l1 = selected.computeLuminance();
          final double l2 = datosNivel.backgroundColor.computeLuminance();
          currentRatio = (math.max(l1, l2) + 0.05) / (math.min(l1, l2) + 0.05);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // CAJA DE VISTA PREVIA (Cambia dinámicamente según el color seleccionado)
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: datosNivel.backgroundColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    datosNivel.previewTextTop,
                    style: TextStyle(
                      color: controller.colorSeleccionado ?? Colors.transparent,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                    ),
                  ),
                  Text(
                    datosNivel.previewTextBottom,
                    style: TextStyle(
                      color: controller.colorSeleccionado ?? Colors.transparent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4.0,
                    ),
                  ),
                  if (controller.colorSeleccionado == null)
                    Text(
                      "Selecciona una opción para probar",
                      style: TextStyle(
                        color: datosNivel.backgroundColor.computeLuminance() > 0.5
                            ? Colors.black45
                            : Colors.white54,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else if (currentRatio != null)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "CONTRASTE: ${currentRatio.toStringAsFixed(1)}:1",
                        style: TextStyle(
                          color: selected,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "OPCIONES DE COLOR DE TEXTO:",
              textAlign: TextAlign.center,
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
              children: controller.opciones.map((color) {
                final bool seleccionado = controller.colorSeleccionado == color;

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: seleccionado ? const Color(0xFFFF9F1C) : Colors.transparent,
                      width: 3.5,
                    ),
                  ),
                  child: GameButton(
                    width: 70,
                    height: 70,
                    borderRadius: 16,
                    backgroundColor: color,
                    shadowColor: _getShadowColor(color),
                    onTap: () => controller.seleccionarColor(color),
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
