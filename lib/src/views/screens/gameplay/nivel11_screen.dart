import 'package:flutter/material.dart';
import '../../../controllers/nivel11_controller.dart';
import '../../../models/level_model.dart';
import 'base_gameplay_screen.dart';

class Nivel11Screen extends StatelessWidget {
  final int nivelInicial;

  const Nivel11Screen({super.key, required this.nivelInicial});

  @override
  Widget build(BuildContext context) {
    return BaseGameplayScreen<AtmosphereLevelModel, Nivel11Controller>(
      nivel: nivelInicial,
      controllerFactory: (context) => Nivel11Controller(nivelInicial: nivelInicial),
      gameFieldBuilder: (context, controller) {
        final datosNivel = controller.datosNivel;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "OPCIONES DE PALETAS DE COLOR:",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...datosNivel.optionPalettes.map((palette) {
              final bool seleccionada = controller.paletaSeleccionada == palette;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () => controller.seleccionarPaleta(palette),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B2332),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: seleccionada ? const Color(0xFFFF9F1C) : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: palette.map((color) {
                              return Expanded(
                                child: Container(
                                  height: 48,
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          seleccionada ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                          color: seleccionada ? const Color(0xFFFF9F1C) : Colors.white24,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
