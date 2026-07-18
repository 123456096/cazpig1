import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../controllers/user_controller.dart';

class PerfilScreen extends StatelessWidget {
  final String? correo;
  final String? edad;

  const PerfilScreen({
    super.key,
    this.correo,
    this.edad,
  });


  @override
  Widget build(BuildContext context) {
    final userController = UserController();

    return ListenableBuilder(
      listenable: userController,
      builder: (context, child) {
        final user = userController.currentUser;

        
        final Map<String, Color> avatarBorderColors = {
          "assets/avatar/avatar1.jpeg": Colors.deepOrange.shade300,
          "assets/avatar/avatar2.jpeg": Colors.blue.shade400,
          "assets/avatar/avatar3.jpeg": Colors.blueGrey.shade300,
          "assets/avatar/avatar4.jpeg": Colors.green.shade600,
          "assets/avatar/avatar5.jpeg": Colors.brown.shade400,
          "assets/avatar/avatar6.jpeg": Colors.purple.shade400,
        };
        final Color avatarColor = avatarBorderColors[user.avatarUrl] ?? Colors.deepOrange.shade300;

        
        Color levelColor;
        if (user.level < 20) {
          levelColor = Colors.brown.shade400; // Novato
        } else if (user.level < 50) {
          levelColor = Colors.blue.shade400; // Intermedio
        } else if (user.level < 100) {
          levelColor = Colors.deepOrange.shade300; // Experto
        } else {
          levelColor = Colors.purple.shade400; // Maestro
        }

        return Stack(
          children:[
            Positioned.fill(
              child:Image.asset(
                'assets/imagenes/fondo.jpeg',
                fit:BoxFit.cover 
              ),
                  ),
          

        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C3545).withOpacity(0.4),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _mostrarGaleriaAvatares(context, userController),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: avatarColor,
                                  child: CircleAvatar(
                                    radius: 37,
                                    backgroundColor: Colors.white,
                                    backgroundImage: AssetImage(user.avatarUrl),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(221, 255, 255, 255)),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      user.title,
                                      style: TextStyle(
                                          color: Colors.grey.shade400, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // XP en el medio
                          Column(
                            children: [
                              Text('${user.xp} XP',
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              const SizedBox(height: 4),
                              Text('Puntos Totales',
                                  style: TextStyle(
                                      color: Colors.grey.shade400, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -10,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: levelColor,
                          boxShadow: [
                            BoxShadow(
                              color: levelColor.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Text('Nvl ${user.level}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppTheme.degradadoGlow.createShader(bounds),
                      child: const Text(
                        "Logros Desbloqueados",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
            _buildBadge(
              icon: Icons.brush_rounded,
              title: "Primer Trazo",
              color: Colors.green.shade400,
              isUnlocked: user.badges.contains("Primer Trazo"),
            ),
            _buildBadge(
              icon: Icons.local_fire_department_rounded,
              title: "Racha Color",
              color: Colors.orange.shade400,
              isUnlocked: user.badges.contains("Racha Color"),
            ),
            _buildBadge(
              icon: Icons.auto_awesome_rounded,
              title: "Estudiante Estrella",
              color: Colors.purple.shade700,
              isUnlocked: user.badges.contains("Estudiante Estrella"),
            ),
            _buildBadge(
              icon: Icons.shield_rounded,
              title: "Sin Mancharse",
              color: Colors.blue.shade400,
              isUnlocked: user.badges.contains("Sin Mancharse"),
            ),
             _buildBadge(
              icon: Icons.visibility_rounded,
              title: "Ojo Entrenado",
              color: Colors.teal.shade400,
              isUnlocked: user.badges.contains("Ojo Entrenado"),
            ),
            _buildBadge(
              icon: Icons.auto_awesome_rounded,
              title: "Ojo Mágico",
              color: Colors.purple.shade700,
              isUnlocked: user.badges.contains("Ojo Mágico"),
            ),
             _buildBadge(
              icon: Icons.auto_awesome_rounded,
              title: "Cazador Definitivo",
              color: Colors.blue.shade700,
              isUnlocked: user.badges.contains("Cazador Definitivo"),
            ),
             _buildBadge(
              icon: Icons.auto_awesome_rounded,
              title: "Velocidad luz",
              color: Colors.purple.shade700,
              isUnlocked: user.badges.contains("Velocidad luz"),
            ),
             _buildBadge(
              icon: Icons.auto_awesome_rounded,
              title: "En la zona",
              color: Colors.red.shade700,
              isUnlocked: user.badges.contains("En la zona"),
            ),
             _buildBadge(
              icon: Icons.auto_awesome_rounded,
              title: "Prueba y error",
              color: Colors.teal.shade700,
              isUnlocked: user.badges.contains("Prueba y error"),
            ),
             _buildBadge(
              icon: Icons.auto_awesome_rounded,
              title: "Linea Recta",
              color: Colors.yellow.shade700,
              isUnlocked: user.badges.contains("Linea Recta"),
            ),
            
          ],
                ),
              ],
            ),
          ),
        ),
          ],
        );
      },
    );
  }


  Widget _buildBadge({
  required IconData icon,
  required String title,
  required Color color,
  required bool isUnlocked,
}) {
  // Configuración de colores estilo Flat Design
  final Color backgroundColor = isUnlocked ? color.withOpacity(0.15) : const Color(0xFF2C3545).withOpacity(0.5);
  final Color iconColor = isUnlocked ? color : Colors.grey.shade600;
  final Color textColor = isUnlocked ? Colors.white.withOpacity(0.9) : Colors.grey.shade500;

  return Container(
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20),
      // Muestra sombra solo si está desbloqueado
      boxShadow: isUnlocked 
          ? [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ]
          : null, 
      // Borde sutil para ambos estados
      border: Border.all(
        color: isUnlocked ? color.withOpacity(0.3) : Colors.grey.shade800,
        width: 2,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isUnlocked ? icon : Icons.lock_outline_rounded, // Candado si está bloqueado
          size: 36,
          color: iconColor,
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ],
    ),
  );
}
  
void _mostrarGaleriaAvatares(BuildContext context, UserController controller) {
  // Lista de los avatares que tienes en tus assets
  final List<String> avataresDisponibles = [
    "assets/avatar/avatar1.jpeg",
    "assets/avatar/avatar2.jpeg",
    "assets/avatar/avatar3.jpeg",
    "assets/avatar/avatar4.jpeg",
    "assets/avatar/avatar5.jpeg",
    "assets/avatar/avatar6.jpeg",
  ];

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Selecciona tu Avatar",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: avataresDisponibles.length,
              itemBuilder: (context, index) {
                final avatar = avataresDisponibles[index];
                return GestureDetector(
                  onTap: () async {
                    // 1. Llamamos a la lógica del controlador para guardar el cambio
                    await controller.actualizarPerfil(
                      nuevoNombre: controller.currentUser.name, 
                      nuevoAvatar: avatar,
                    );
                    // 2. Cerramos el modal
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    backgroundImage: AssetImage(avatar),
                    backgroundColor: Colors.grey.shade100,
                  ),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

}
