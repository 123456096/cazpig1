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

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepOrange.shade300.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.deepOrange.shade300,
                    child: CircleAvatar(
                      radius: 51,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person_rounded, size: 65, color: Colors.deepOrange.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Elena Cruz', 
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                
                Text(
                  user.email,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 36),
                          const SizedBox(height: 6),
                          Text('${user.xp} XP', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Puntos Totales', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                        ],
                      ),
                      Container(width: 1, height: 40, color: Colors.grey.shade200),
                      Column(
                        children: [
                          Icon(Icons.workspace_premium_rounded, color: Colors.deepOrange.shade300, size: 36),
                          const SizedBox(height: 6),
                          Text('Nivel ${user.level}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(user.title, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => AppTheme.degradadoGlow.createShader(bounds),
                      child: const Text(
                        "Logros Desbloqueados",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
                    _buildBadge(Icons.brush_rounded, user.badges.contains("Primer Trazo") ? "Primer Trazo" : "Bloqueado", Colors.green.shade400),
                    _buildBadge(Icons.local_fire_department_rounded, user.badges.contains("Racha Color") ? "Racha Color" : "Bloqueado", Colors.orange.shade400),
                    _buildBadge(Icons.auto_awesome_rounded, user.badges.contains("Ojo Mágico") ? "Ojo Mágico" : "Bloqueado", Colors.purple.shade400),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBadge(IconData icon, String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: color),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
