import 'package:flutter/material.dart';
import '../../../controllers/nivel1_controller.dart';
import '../../../models/level_model.dart';
import '../../widgets/game_button.dart';
import 'base_gameplay_screen.dart';

class Nivel1Screen extends StatelessWidget {
  final int nivelInicial;

  const Nivel1Screen({super.key, required this.nivelInicial});

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
    return BaseGameplayScreen<MixLevelModel, Nivel1Controller>(
      nivel: nivelInicial,
      controllerFactory: (context) => Nivel1Controller(nivelInicial: nivelInicial),
      gameFieldBuilder: (context, controller) {
        return Column(
          children: [
            // Mostrar los canales combinados con botón de reinicio
            Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _construirCanal(controller.colorSeleccionado1),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(Icons.add_rounded, color: Colors.white, size: 28),
                    ),
                    _construirCanal(controller.colorSeleccionado2),
                  ],
                ),
                if (controller.colorSeleccionado1 != null || controller.colorSeleccionado2 != null)
                  Positioned(
                    right: 20,
                    child: IconButton(
                      onPressed: controller.reiniciarSeleccion,
                      icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent, size: 30),
                      tooltip: "Limpiar mezcla",
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              "Selecciona dos pigmentos para mezclar:",
              style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Opciones como botones 3D
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                Colors.red,
                Colors.blue,
                Colors.yellow,
                Colors.green,
                Colors.white
              ].map((color) {
                return GameButton(
                  width: 65,
                  height: 65,
                  borderRadius: 16,
                  backgroundColor: color,
                  shadowColor: _getShadowColor(color),
                  onTap: () => controller.seleccionarColor(color),
                  child: const SizedBox.shrink(),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _construirCanal(Color? color) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color ?? const Color(0xFF141824),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color != null ? const Color(0xFF00C897) : const Color(0xFF3F4B62),
          width: 2.5,
        ),
      ),
    );
  }
}
