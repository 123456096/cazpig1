import 'package:flutter/material.dart';
import '../../controllers/user_controller.dart';

class ProgressHeader extends StatelessWidget implements PreferredSizeWidget {
  const ProgressHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(52.0);

  @override
  Widget build(BuildContext context) {
    final userController = UserController();

    return ListenableBuilder(
      listenable: userController,
      builder: (context, child) {
        final user = userController.currentUser;

        return Container(
          width: double.infinity,
          height: 52,
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          alignment: Alignment.center,
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: Stack(
              children: [
                // 1. IMAGEN DE FONDO
                Positioned.fill(
                  child: Image.asset(
                    'assets/imagenes/barra.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),

                // 2. CAPA DE ICONOS Y TEXTOS CORREGIDA CON BLOQUES FIJOS
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      children: [
                        // Espacio inicial exacto para saltarse el título "RUTA DEL PIGMENTO"
                        const Spacer(flex: 38),

                        // ==================== SECCIÓN VIDAS ====================
                        Expanded(
                          flex: 16,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/imagenes/corazon.png',
                                height: 21,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 1), // Pegadito al recuadro gris
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (user.lives < 5) {
                                      _mostrarCompraVidas(context, userController);
                                    }
                                  },
                                  child: Center(
                                    child: Text(
                                      '${user.lives}',
                                      style: const TextStyle(
                                        color: Color(0xFFFFF3E0),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(flex: 1), // Separador mínimo entre bloques

                        // ==================== SECCIÓN RACHA ====================
                        Expanded(
                          flex: 16,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/imagenes/horno.png',
                                height: 21,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 1), // Pegadito al recuadro gris
                              Expanded(
                                child: Center(
                                  child: Text(
                                    '${user.streak}',
                                    style: const TextStyle(
                                      color: Color(0xFFFFF3E0),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(flex: 1), // Separador mínimo entre bloques

                        // ==================== SECCIÓN PIGMENTOS ====================
                        Expanded(
                          flex: 19, // Un pelincito más ancho para soportar cifras de 4 dígitos como "1791"
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/imagenes/cristal.png',
                                height: 21,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 1), // Pegadito al recuadro gris
                              Expanded(
                                child: Center(
                                  child: Text(
                                    '${user.pigments}',
                                    style: const TextStyle(
                                      color: Color(0xFFFFF3E0),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Espacio de salida final a la derecha del pergamino
                        const Spacer(flex: 4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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