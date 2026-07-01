import 'package:flutter/material.dart';
import '../../controllers/registro_controller.dart';
import '../../controllers/user_controller.dart';
import '../../theme/app_theme.dart';
import '../widgets/game_button.dart';
import 'menu_principal_screen.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = RegistroController();
  bool _isOffline = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _intentarRegistro() {
    if (_formKey.currentState!.validate()) {
      final user = _controller.registrarUsuario();
      UserController().inicializarUsuario(
        email: user.email,
        age: user.age,
        isOffline: _isOffline,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MenuPrincipalScreen(
            correo: user.email,
            edad: user.age,
          ),
        ), 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.fondoPastel,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => AppTheme.degradadoGlow.createShader(bounds),
                    child: const Text(
                      "Registro de Jugador",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            blurRadius: 8.0,
                            color: Colors.orangeAccent,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(Icons.palette_outlined, size: 50, color: Colors.deepOrange.shade300),
                        const SizedBox(height: 24),

                        TextFormField(
                          controller: _controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                          decoration: _inputDecoration('Correo Electrónico', Icons.email_outlined),
                          validator: _controller.validarEmail,
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _controller.edadController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                          decoration: _inputDecoration('Edad', Icons.cake_outlined),
                          validator: _controller.validarEdad,
                        ),
                        const SizedBox(height: 20),

                        // Switch de Modo Offline
                        SwitchListTile(
                          title: const Text(
                            'Modo Offline',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14),
                          ),
                          subtitle: const Text(
                            'Juega localmente guardando el progreso en el dispositivo',
                            style: TextStyle(fontSize: 11),
                          ),
                          secondary: Icon(Icons.cloud_off_rounded, color: Colors.deepOrange.shade300),
                          value: _isOffline,
                          onChanged: (bool value) {
                            setState(() => _isOffline = value);
                          },
                        ),
                        const SizedBox(height: 30),

                        // Botón Mecánico 3D
                        GameButton(
                          backgroundColor: const Color(0xFF58CC02),
                          shadowColor: const Color(0xFF46A302),
                          onTap: _intentarRegistro,
                          child: const Text(
                            '¡Comenzar Aventura!', 
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
      prefixIcon: Icon(icon, color: Colors.deepOrange.shade300),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300), 
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFFF7F50), width: 2), 
        borderRadius: BorderRadius.circular(16),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent), 
        borderRadius: BorderRadius.circular(16),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 2), 
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
