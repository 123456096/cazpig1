import 'package:flutter/material.dart';
import '../../controllers/game_settings_controller.dart';
import '../../controllers/user_controller.dart';
import '../../theme/app_theme.dart';
import '../widgets/animated_background.dart';

class AjustesScreen extends StatefulWidget {
  const AjustesScreen({super.key});

  @override
  State<AjustesScreen> createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  final GameSettingsController _controller = GameSettingsController();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final settings = _controller.settings;
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/imagenes/fondo.jpeg',
                fit:BoxFit.cover,
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildSettingsCard(
                      children: [
                        _buildSwitchTile(
                          title: 'Música de fondo',
                          subtitle: 'Melodías ambientales de laboratorio',
                          icon: Icons.music_note_rounded,
                          value: settings.musicActive,
                          onChanged: (value) => _controller.setMusicActive(value),
                        ),
                        _buildDivider(),
                        _buildSwitchTile(
                          title: 'Vibraciones',
                          subtitle: 'Efectos táctiles al acertar o fallar',
                          icon: Icons.vibration_rounded,
                          value: settings.vibrationActive,
                          onChanged: (value) => _controller.setVibrationActive(value),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSettingsCard(
                      children: [
                        _buildSwitchTile(
                          title: 'Alertas de Desafíos',
                          subtitle: 'Recordatorios para cazar nuevos pigmentos',
                          icon: Icons.notifications_active_rounded,
                          value: settings.notificationsActive,
                          onChanged: (value) => _controller.setNotificationsActive(value),
                        ),
                        _buildDivider(),
                        _buildInfoTile(
                          title: 'Idioma del juego',
                          icon: Icons.translate_rounded,
                          value: settings.language,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _mostrarConfirmacionReinicio(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.withOpacity(0.15),
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(color: Colors.redAccent, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.delete_forever_rounded),
                        label: const Text(
                          "REINICIAR PROGRESO",
                          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: Text(
                        'Cazadores de Pigmentos v1.0.0',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C3545).withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade400)),
      secondary: Icon(icon, color: Colors.cyanAccent),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.cyanAccent,
      inactiveTrackColor: Colors.grey.shade800,
    );
  }

  Widget _buildInfoTile({
    required String title,
    required IconData icon,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.cyanAccent),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      trailing: Text(value, style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
      onTap: () {}, // Placeholder for future functionality
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.white.withOpacity(0.1),
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _construirSeccionTitulo(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        titulo,
        style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black45, letterSpacing: 1.2),
      ),
    );
  }
}

  void _mostrarConfirmacionReinicio(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF161A22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
              SizedBox(width: 12),
              Text("¿Confirmar Reinicio?", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            "Esta acción borrará todo tu progreso local y sincronizado de niveles, XP, diamantes y rachas. Esto no se puede deshacer.",
            style: TextStyle(color: Color(0xFF6B7A94), fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancelar", style: TextStyle(color: Colors.white70)),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent.withOpacity(0.1),
                foregroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                Navigator.pop(dialogContext); // Cierra el modal
                
                await UserController().reiniciarTodoElProgreso();

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Progreso reiniciado con éxito"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text("Sí, reiniciar", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        );
      },
    );
  }
}

