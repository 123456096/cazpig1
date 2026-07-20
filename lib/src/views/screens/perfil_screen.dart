import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../controllers/user_controller.dart';
import '../../services/auth_service.dart';
import 'login_screen.dart';

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
          levelColor = Colors.brown.shade400; 
        } else if (user.level < 50) {
          levelColor = Colors.blue.shade400; 
        } else if (user.level < 100) {
          levelColor = Colors.deepOrange.shade300; 
        } else {
          levelColor = Colors.purple.shade400; 
        }

        return Scaffold(
          backgroundColor: Colors.transparent, // Evita cualquier barra o fondo negro residual
          body: Stack(
            children: [
              // 1. FONDO GENERAL (A pantalla completa real, pasando por debajo de la barra de estado)
              Positioned.fill(
                child: Image.asset(
                  'assets/imagenes/fondo.jpeg',
                  fit: BoxFit.cover,
                ),
              ),

              // 2. CONTENIDO SCROLLABLE PROTEGIDO
              Positioned.fill(
                child: SafeArea(
                  top: true,
                  bottom: true,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                      child: Column(
                        children: [
                          // Espaciado superior mínimo y controlado
                          const SizedBox(height: 20),

                          // TARJETA DE PERFIL
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 240, 
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/imagenes/tarjeta.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    // AVATAR
                                    Positioned(
                                      top: 25,
                                      left: 28,
                                      child: GestureDetector(
                                        onTap: () => _mostrarGaleriaAvatares(context, userController),
                                        child: CircleAvatar(
                                          radius: 44,
                                          backgroundColor: avatarColor.withOpacity(0.6),
                                          child: CircleAvatar(
                                            radius: 41,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: AssetImage(user.avatarUrl),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // NOMBRE Y RANGO
                                    Positioned(
                                      top: 35,
                                      left: 140,
                                      right: 40,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF2B1810), 
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            user.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Color(0xFF5D4037),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // PUNTOS XP
                                    Positioned(
                                      bottom: 64,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Text(
                                          '${user.xp} XP',
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2B1810),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // INSIGNIA FLOTANTE DE NIVEL
                              Positioned(
                                top: -12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.all(11),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: levelColor,
                                    border: Border.all(color: Colors.white, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: levelColor.withOpacity(0.4),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'Nvl ${user.level}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // BOTÓN DE CERRAR SESIÓN
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF301A2E),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                              ),
                              icon: const Icon(Icons.exit_to_app_rounded, color: Colors.white),
                              label: const Text(
                                'Cerrar sesión',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                await AuthService().signOut();
                                if (context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 24),

                          // TÍTULO DE LOGROS
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

                          // REJILLA DE LOGROS TRANSPARENTES
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
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
    final Color backgroundColor = isUnlocked
        ? color.withOpacity(0.15)
        : const Color(0xFF2C3545).withOpacity(0.35); 
    final Color iconColor = isUnlocked ? color : Colors.grey.shade600;
    final Color textColor = isUnlocked ? Colors.white.withOpacity(0.9) : Colors.grey.shade500;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: color.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
        border: Border.all(
          color: isUnlocked ? color.withOpacity(0.35) : Colors.white.withOpacity(0.08),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isUnlocked ? icon : Icons.lock_outline_rounded,
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
                      await controller.actualizarPerfil(
                        nuevoNombre: controller.currentUser.name,
                        nuevoAvatar: avatar,
                      );
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