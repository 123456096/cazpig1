import 'package:flutter/material.dart';
import '../../../controllers/nivel8_controller.dart';
import '../../../models/level_model.dart';
import 'base_gameplay_screen.dart';

class Nivel8Screen extends StatelessWidget {
  final int nivelInicial;

  const Nivel8Screen({super.key, required this.nivelInicial});

  @override
  Widget build(BuildContext context) {
    return BaseGameplayScreen<TempLevelModel, Nivel8Controller>(
      nivel: nivelInicial,
      controllerFactory: (context) => Nivel8Controller(nivelInicial: nivelInicial),
      gameFieldBuilder: (context, controller) {
        return Column(
          children: [
            // PALETA DE PIGMENTOS DISPONIBLES (ARRISTRABLES)
            const Text(
              "PIGMENTOS EN FILTRO DE TEMPERATURA:",
              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              height: 100,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF131720),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.08), width: 1.5),
              ),
              child: controller.available.isEmpty
                  ? const Center(
                      child: Text(
                        "¡Todos los pigmentos han sido clasificados!",
                        style: TextStyle(color: Colors.greenAccent, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: controller.available.map((color) {
                          final String hex = "#${color.value.toRadixString(16).substring(2).toUpperCase()}";
                          
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: LongPressDraggable<Color>(
                              data: color,
                              feedback: _buildDraggableCard(color, hex, true),
                              childWhenDragging: Opacity(
                                opacity: 0.3,
                                child: _buildDraggableCard(color, hex, false),
                              ),
                              child: _buildDraggableCard(color, hex, false),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
            ),
            const SizedBox(height: 40),
            // FRASCOS DE RECEPCIÓN (CÁLIDO Y FRÍO)
            Row(
              children: [
                // FRASCO CÁLIDO
                Expanded(
                  child: _buildDragTarget(
                    context: context,
                    controller: controller,
                    zone: "warm",
                    title: "ZONA CÁLIDA ☀️",
                    borderColor: Colors.redAccent,
                    colors: controller.warm,
                  ),
                ),
                const SizedBox(width: 16),
                // FRASCO FRÍO
                Expanded(
                  child: _buildDragTarget(
                    context: context,
                    controller: controller,
                    zone: "cold",
                    title: "ZONA FRÍA ❄️",
                    borderColor: Colors.blueAccent,
                    colors: controller.cold,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildDraggableCard(Color color, String hex, bool isFeedback) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white30, width: 1.5),
          boxShadow: isFeedback
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.6),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            hex,
            style: const TextStyle(color: Colors.white, fontSize: 8, fontFamily: 'monospace', fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildDragTarget({
    required BuildContext context,
    required Nivel8Controller controller,
    required String zone,
    required String title,
    required Color borderColor,
    required List<Color> colors,
  }) {
    return DragTarget<Color>(
      onAcceptWithDetails: (details) {
        controller.classifyColor(details.data, zone);
      },
      builder: (context, candidateData, rejectedData) {
        final bool isOver = candidateData.isNotEmpty;

        return Container(
          height: 220,
          decoration: BoxDecoration(
            color: isOver ? borderColor.withOpacity(0.08) : const Color(0xFF1B2332),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isOver ? borderColor : borderColor.withOpacity(0.2),
              width: isOver ? 2.5 : 1.5,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(color: borderColor, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 0.5),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: colors.isEmpty
                    ? Center(
                        child: Text(
                          "Arrastra\naquí",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: colors.length,
                        itemBuilder: (context, index) {
                          final Color color = colors[index];
                          return GestureDetector(
                            onTap: () => controller.classifyColor(color, "available"),
                            child: Container(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white30, width: 1),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.close_rounded, color: Colors.white70, size: 18),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
