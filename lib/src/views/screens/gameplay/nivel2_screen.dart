import 'package:flutter/material.dart';
import '../../../controllers/nivel2_controller.dart';
import '../../../models/level_model.dart';
import '../../widgets/game_button.dart';
import 'base_gameplay_screen.dart';

class Nivel2Screen extends StatelessWidget {
  final int nivelInicial;

  const Nivel2Screen({super.key, required this.nivelInicial});

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
    final int crossAxis = ancho > 600 ? 4 : 2;

    return BaseGameplayScreen<SearchLevelModel, Nivel2Controller>(
      nivel: nivelInicial,
      controllerFactory: (context) => Nivel2Controller(nivelInicial: nivelInicial),
      instructionCardBuilder: (context, controller) {
        final datos = controller.datosNivel;
        return Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: const Color(0xFF2C3545),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF3F4B62), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                datos.context.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFFF9F1C),
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                datos.instruction, // mapped to brief
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      },
      gameFieldBuilder: (context, controller) {
        return Column(
          children: [
            const Text(
              "Selecciona el color corporativo correcto:",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxis,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.15,
              ),
              itemCount: controller.opciones.length,
              itemBuilder: (context, index) {
                final item = controller.opciones[index];
                final Color itemColor = item["color"];
                final bool seleccionado = controller.colorSeleccionado == itemColor;

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: seleccionado ? const Color(0xFFFF9F1C) : Colors.transparent,
                      width: 3.5,
                    ),
                  ),
                  child: GameButton(
                    backgroundColor: itemColor,
                    shadowColor: _getShadowColor(itemColor),
                    borderRadius: 20,
                    onTap: () => controller.seleccionarColor(itemColor),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 6, left: 4, right: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item["nombre"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
