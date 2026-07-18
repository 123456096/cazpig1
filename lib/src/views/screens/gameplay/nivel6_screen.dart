import 'package:flutter/material.dart';
import '../../../controllers/nivel6_controller.dart';
import '../../../models/level_model.dart';
import '../../widgets/game_button.dart';
import 'base_gameplay_screen.dart';

class Nivel6Screen extends StatefulWidget {
  final int nivelInicial;

  const Nivel6Screen({super.key, required this.nivelInicial});

  @override
  State<Nivel6Screen> createState() => _Nivel6ScreenState();
}

class _Nivel6ScreenState extends State<Nivel6Screen> {
  String? activeSimulacion;

  Color _getShadowColor(Color color) {
    return Color.fromARGB(
      (color.a * 255.0).round().clamp(0, 255),
      (color.r * 255.0 * 0.7).round().clamp(0, 255),
      (color.g * 255.0 * 0.7).round().clamp(0, 255),
      (color.b * 255.0 * 0.7).round().clamp(0, 255),
    );
  }

  String _getNombreColor(Color color) {
    final val = color.value & 0xFFFFFF;
    if (val == 0xE53935) return "ROJO CADMIO";
    if (val == 0x43A047) return "VERDE VIRIDIÁN";
    if (val == 0x795548) return "MARRÓN TIERRA";
    if (val == 0xFFFFB300) return "AMARILLO CROMO";
    if (val == 0x8E24AA) return "VIOLETA ZEN";
    if (val == 0x1E88E5) return "AZUL COBALTO";
    if (val == 0x00BEC4) return "TURQUESA VITAL";
    
    if (val == 0xFFC62828) return "ROJO OSCURO";
    if (val == 0xFF0288D1) return "CELESTE";
    if (val == 0xFFD84315) return "NARANJA OSCURO";
    if (val == 0xFF757575) return "GRIS";
    
    if (val == 0xFFC2185B) return "MAGENTA";
    if (val == 0xFFFFFFFF) return "BLANCO";
    if (val == 0xFF6A1B9A) return "PÚRPURA";
    if (val == 0xFF558B2F) return "VERDE OLIVA";
    
    if (val == 0xFF9E9D24) return "LIMÓN";
    if (val == 0xFF1976D2) return "AZUL REY";
    if (val == 0xFFEF6C00) return "NARANJA";
    if (val == 0xFF9E9E9E) return "GRIS CLARO";
    
    if (val == 0xFF4E342E) return "CAFÉ";
    if (val == 0xFFFF4081) return "ROSADO NEÓN";
    
    if (val == 0xFFFFD54F) return "AMARILLO CLARO";
    if (val == 0xFF4A148C) return "PÚRPURA OSCURO";
    if (val == 0xFFFFB74D) return "NARANJA CLARO";
    if (val == 0xFFF8BBD0) return "ROSADO CLARO";
    
    if (val == 0xFF00ACC1) return "TURQUESA";
    if (val == 0xFFF4511E) return "ROJO NARANJA";
    if (val == 0xFF4FC3F7) return "CELESTE CLARO";
    if (val == 0xFF4CAF50) return "VERDE CLARO";
    
    return "COLOR";
  }

  Widget _buildFiltroButton(String label, String value) {
    final bool activo = activeSimulacion == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          activeSimulacion = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: activo ? const Color(0xFFFF9F1C).withOpacity(0.12) : const Color(0xFF141824),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: activo ? const Color(0xFFFF9F1C) : const Color(0xFF3F4B62),
            width: 1.5,
          ),
          boxShadow: activo
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF9F1C).withOpacity(0.2),
                    blurRadius: 8,
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: activo ? const Color(0xFFFF9F1C) : Colors.white60,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseGameplayScreen<BlindLevelModel, Nivel6Controller>(
      nivel: widget.nivelInicial,
      controllerFactory: (context) => Nivel6Controller(nivelInicial: widget.nivelInicial),
      gameFieldBuilder: (context, controller) {
        final datosNivel = controller.datosNivel;
        activeSimulacion ??= datosNivel.blindType;

        Widget mainContent = Column(
          children: [
            // SELECCIÓN DE FILTROS DE SIMULACIÓN
            const Text(
              "FILTRO DE SIMULACIÓN DE ACCESIBILIDAD:",
              style: TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFiltroButton("REAL", "Ninguno"),
                  const SizedBox(width: 6),
                  _buildFiltroButton("PROTANOPIA", "Protanopia"),
                  const SizedBox(width: 6),
                  _buildFiltroButton("DEUTERANOPIA", "Deuteranopia"),
                  const SizedBox(width: 6),
                  _buildFiltroButton("TRITANOPIA", "Tritanopia"),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Alterna entre filtros para simular diferentes tipos de daltonismo o pulsa 'REAL' para contrastar.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 9,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // COMPARADOR DE SIMULACIÓN DE COLOR
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // COLOR OBJETIVO
                Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: datosNivel.targetColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: datosNivel.targetColor.withValues(alpha: 0.4),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.palette, color: Colors.white70, size: 30),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      datosNivel.blindType == "Protanopia"
                          ? "ROJO OBJETIVO"
                          : (datosNivel.blindType == "Deuteranopia" ? "VERDE OBJETIVO" : "AZUL OBJETIVO"),
                      style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.compare_arrows_rounded, color: Colors.white30, size: 28),
                ),
                // COLOR SELECCIONADO
                Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: controller.colorSeleccionado ?? Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: controller.colorSeleccionado != null ? const Color(0xFFFF9F1C) : Colors.white12,
                          width: 2.5,
                        ),
                        boxShadow: controller.colorSeleccionado != null
                            ? [
                                BoxShadow(
                                  color: controller.colorSeleccionado!.withValues(alpha: 0.4),
                                  blurRadius: 16,
                                ),
                              ]
                            : null,
                      ),
                      child: controller.colorSeleccionado == null
                          ? Center(
                              child: Text(
                                "?",
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.15), fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            )
                          : const Icon(Icons.check_circle_outline_rounded, color: Colors.white70, size: 30),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.colorSeleccionado == null ? "SIN SELECCIÓN" : "TU SELECCIÓN",
                      style: TextStyle(
                        color: controller.colorSeleccionado != null ? const Color(0xFFFF9F1C) : Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              "OPCIONES DE COLOR ACCESIBLE:",
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
                      padding: const EdgeInsets.only(bottom: 6, left: 4, right: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _getNombreColor(color),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              "#${color.value.toRadixString(16).substring(2).toUpperCase()}",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 7,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );

        if (activeSimulacion == "Ninguno") {
          return mainContent;
        } else {
          List<double> matrix;
          if (activeSimulacion == "Protanopia") {
            matrix = const [
              0.567, 0.433, 0, 0, 0,
              0.558, 0.442, 0, 0, 0,
              0, 0.242, 0.758, 0, 0,
              0, 0, 0, 1, 0,
            ];
          } else if (activeSimulacion == "Deuteranopia") {
            matrix = const [
              0.625, 0.375, 0, 0, 0,
              0.7, 0.3, 0, 0, 0,
              0, 0.3, 0.7, 0, 0,
              0, 0, 0, 1, 0,
            ];
          } else {
            // Tritanopia
            matrix = const [
              0.95, 0.05, 0, 0, 0,
              0, 0.433, 0.567, 0, 0,
              0, 0.475, 0.525, 0, 0,
              0, 0, 0, 1, 0,
            ];
          }
          return ColorFiltered(
            colorFilter: ColorFilter.matrix(matrix),
            child: mainContent,
          );
        }
      },
    );
  }
}
