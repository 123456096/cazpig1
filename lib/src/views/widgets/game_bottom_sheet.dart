import 'package:flutter/material.dart';
import '../../controllers/sound_manager.dart';
import 'game_button.dart';

class GameBottomSheet {
  /// Muestra el modal inferior de Victoria
  static void mostrarVictoria({
    required BuildContext context,
    required int pigmentosGanados,
    required VoidCallback onContinuar,
  }) {
    SoundManager().playSuccess();
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFFE8F5E9), // Fondo verde pastel
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Color(0xFF58CC02), size: 40),
                  const SizedBox(width: 12),
                  const Text(
                    "¡Excelente Trabajo!",
                    style: TextStyle(
                      color: Color(0xFF1B5E20),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Recompensa: ",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  Text(
                    "+$pigmentosGanados 💎 (+100 XP)",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF00C897),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              GameButton(
                backgroundColor: const Color(0xFF58CC02),
                shadowColor: const Color(0xFF46A302),
                onTap: () {
                  Navigator.pop(context);
                  onContinuar();
                },
                child: const Text(
                  "CONTINUAR",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Muestra el modal inferior de Derrota
  static void mostrarDerrota({
    required BuildContext context,
    required String mensaje,
    required VoidCallback onReintentar,
    required VoidCallback onVolver,
  }) {
    SoundManager().playError();
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFFFFEBEE), // Fondo rojo pastel
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.error_rounded, color: Color(0xFFEA2B2B), size: 40),
                  const SizedBox(width: 12),
                  const Text(
                    "¡Casi lo logras!",
                    style: TextStyle(
                      color: Color(0xFFC62828),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                mensaje,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black87, fontSize: 15),
              ),
              const SizedBox(height: 8),
              const Text(
                "-1 💚 Vida Restada",
                style: TextStyle(color: Color(0xFFFF4B4B), fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onVolver();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        side: const BorderSide(color: Color(0xFFC62828), width: 1.5),
                      ),
                      child: const Text(
                        "VOLVER AL MAPA",
                        style: TextStyle(color: Color(0xFFC62828), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GameButton(
                      backgroundColor: const Color(0xFFEA2B2B),
                      shadowColor: const Color(0xFFB71C1C),
                      onTap: () {
                        Navigator.pop(context);
                        onReintentar();
                      },
                      child: const Text(
                        "REINTENTAR",
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
