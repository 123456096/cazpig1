import 'package:flutter/material.dart';
import '../../controllers/user_controller.dart';

class ProgressHeader extends StatelessWidget implements PreferredSizeWidget {
  const ProgressHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    final userController = UserController();

    return ListenableBuilder(
      listenable: userController,
      builder: (context, child) {
        final user = userController.currentUser;

        return Container(
          height: 60,
          color: const Color(0xFF141824), // Fondo de barra a juego con el mapa
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SafeArea(
            bottom: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 1. Mostrar estado de conexión
                Row(
                  children: [
                    Icon(
                      user.isOffline ? Icons.cloud_off_rounded : Icons.cloud_done_rounded,
                      color: user.isOffline ? Colors.orange : Colors.greenAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      user.isOffline ? "OFFLINE" : "EN LÍNEA",
                      style: TextStyle(
                        color: user.isOffline ? Colors.orange : Colors.greenAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),

                // 2. Indicadores de Juego
                Row(
                  children: [
                    // Corazón (Vidas)
                    _buildIndicator(
                      icon: Icons.favorite_rounded,
                      iconColor: const Color(0xFFFF4B4B),
                      text: '${user.lives}',
                      onTap: () {
                        if (user.lives < 5) {
                          _mostrarCompraVidas(context, userController);
                        }
                      },
                    ),
                    const SizedBox(width: 14),

                    // Fuego (Racha)
                    _buildIndicator(
                      icon: Icons.local_fire_department_rounded,
                      iconColor: const Color(0xFFFF9600),
                      text: '${user.streak}',
                    ),
                    const SizedBox(width: 14),

                    // Diamante (Pigmentos)
                    _buildIndicator(
                      icon: Icons.diamond_rounded,
                      iconColor: const Color(0xFF1CB0F6),
                      text: '${user.pigments}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIndicator({
    required IconData icon,
    required Color iconColor,
    required String text,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF2C3545),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF3F4B62), width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarCompraVidas(BuildContext context, UserController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: const Color(0xFF1E2638),
        title: const Text(
          "❤️ Rellenar Vidas",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_rounded, color: Color(0xFFFF4B4B), size: 70),
            SizedBox(height: 16),
            Text(
              "¿Quieres reponer tus 5 vidas de inmediato?",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 8),
            Text(
              "Coste: 150 💎",
              style: TextStyle(color: Color(0xFF1CB0F6), fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar", style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            onPressed: () {
              bool exito = controller.comprarVidasConPigmentos();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(exito ? "¡Vidas recargadas al máximo!" : "No tienes suficientes pigmentos 💎"),
                  backgroundColor: exito ? Colors.green : Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF4B4B)),
            child: const Text("Comprar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
