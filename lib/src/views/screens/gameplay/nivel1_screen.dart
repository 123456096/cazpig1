import 'package:flutter/material.dart';
import '../../../controllers/nivel1_controller.dart';
import '../../../models/level_model.dart';
import 'base_gameplay_screen.dart';

class Nivel1Screen extends StatelessWidget {
  final int nivelInicial;

  const Nivel1Screen({super.key, required this.nivelInicial});

  @override
  Widget build(BuildContext context) {
    return BaseGameplayScreen<MixLevelModel, Nivel1Controller>(
      nivel: nivelInicial,
      ocultarBotonComprobar: true, 
      controllerFactory: (context) => Nivel1Controller(nivelInicial: nivelInicial),
      gameFieldBuilder: (context, controller) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _construirPanelObjetivo(controller.datosNivel),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _construirMatrazLaboratorio(controller.colorSeleccionado1, "Matraz Fusión 1"),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Icon(Icons.add, color: Color(0xFF454D5A), size: 28),
                ),
                _construirMatrazLaboratorio(controller.colorSeleccionado2, "Matraz Fusión 2"),
              ],
            ),
            const SizedBox(height: 25),

            if (controller.listoParaComprobar) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF161A22),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: controller.colorResultante.withOpacity(0.5), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: controller.colorResultante.withOpacity(0.2),
                      blurRadius: 12,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Resultado: ", style: TextStyle(color: Color(0xFF6B7A94), fontSize: 13, fontWeight: FontWeight.w500)),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: controller.colorResultante,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: controller.colorResultante.withOpacity(0.6),
                            blurRadius: 6,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${controller.nombreColorResultante} (#${controller.colorResultante.value.toRadixString(16).substring(2).toUpperCase()})",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ] else ...[
              const SizedBox(height: 64), 
            ],

            const Text(
              "Selecciona dos pigmentos para mezclar:",
              style: TextStyle(color: Color(0xFF6B7A94), fontSize: 13),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: controller.opcionesPaleta.map((pigmento) {
                Color col = pigmento.color;
                bool seleccionado = controller.colorSeleccionado1 == col || controller.colorSeleccionado2 == col;

                return GestureDetector(
                  onTap: () async {
                    controller.seleccionarColor(col);

                    if (controller.listoParaComprobar) {
                      await Future.delayed(const Duration(milliseconds: 180));
                      if (context.mounted) {
                        controller.comprobarResultadoAutomatico(context);
                      }
                    }
                  },
                  child: Container(
                    width: 140,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1F29),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: seleccionado ? col : const Color(0xFF2C3444),
                        width: seleccionado ? 2.5 : 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.science, color: col, size: 24),
                            Icon(Icons.colorize, color: col.withOpacity(0.4), size: 14),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${pigmento.formula}  #${col.value.toRadixString(16).substring(2).toUpperCase()}",
                              style: TextStyle(color: col.withOpacity(0.8), fontSize: 9, fontFamily: 'monospace'),
                            ),
                            Text(pigmento.nombre, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 25),

            if (controller.colorSeleccionado1 != null || controller.colorSeleccionado2 != null) ...[
              TextButton(
                onPressed: () => controller.reiniciarSeleccion(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.redAccent.withOpacity(0.8),
                ),
                child: const Text(
                  "Limpiar Matraces",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
              ),
            ] else ...[
              const SizedBox(height: 48), 
            ],
          ],
        );
      },
    );
  }

  Widget _construirPanelObjetivo(MixLevelModel datosNivel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF151922),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF252C3B), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("OBJETIVO", style: TextStyle(color: Color(0xFF6B7A94), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(datosNivel.objective, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Text(
                    "#${datosNivel.colorHex.value.toRadixString(16).substring(2).toUpperCase()}",
                    style: TextStyle(color: datosNivel.colorHex, fontSize: 13, fontFamily: 'monospace', fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text("Sintetiza empleando reactivos primarios", style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0C10),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: datosNivel.colorHex.withOpacity(0.8), width: 1),
            ),
            child: Column(
              children: [
                Icon(Icons.biotech, color: datosNivel.colorHex, size: 30),
                const SizedBox(height: 2),
                Text(datosNivel.objective, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _construirMatrazLaboratorio(Color? color, String tag) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: const Color(0xFF13171F),
            shape: BoxShape.circle,
            border: Border.all(
              color: color ?? const Color(0xFF2A3342),
              width: color != null ? 3.5 : 1.5,
            ),
            boxShadow: color != null
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 16,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          child: Center(
            child: Icon(
              color != null ? Icons.hourglass_full_rounded : Icons.hourglass_empty_rounded,
              color: color ?? const Color(0xFF3F4A5F),
              size: 36,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          tag,
          style: const TextStyle(color: Color(0xFF6B7A94), fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}