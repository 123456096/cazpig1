import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../controllers/registro_controller.dart';
import '../../controllers/user_controller.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../widgets/game_button.dart';
import 'login_screen.dart';
import 'menu_principal_screen.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = RegistroController();
  final AuthService _authService = AuthService();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isOffline = false;
  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _controller.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _intentarRegistro() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await _authService.registerWithEmailAndPassword(
        email: _controller.emailController.text,
        password: _passwordController.text,
      );
      final user = _controller.registrarUsuario();
      UserController().inicializarUsuario(
        email: user.email,
        age: user.age,
        isOffline: _isOffline,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Registro exitoso! Revisa tu bandeja de entrada para verificar tu cuenta antes de iniciar sesión.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MenuPrincipalScreen(
            correo: user.email,
            edad: user.age,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_authService.getErrorMessage(e))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo completar el registro.')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E272E),
              Color(0xFF6C5CE7),
              Color(0xFF00CE99),
              Color(0xFFFF6EC7),
            ],
          ),
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
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C3545).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(Icons.palette_outlined, size: 50, color: Colors.cyanAccent),
                        const SizedBox(height: 24),

                        // Correo
                        TextFormField(
                          controller: _controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                          decoration: _inputDecoration('Correo Electronico', Icons.email_outlined),
                          validator: _controller.validarEmail,
                        ),
                        const SizedBox(height: 20),

                        // Edad
                        TextFormField(
                          controller: _controller.edadController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                          decoration: _inputDecoration('Edad', Icons.cake_outlined),
                          validator: _controller.validarEdad,
                        ),
                        const SizedBox(height: 20),

                        // Contrasena
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_showPassword,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                          decoration: _inputDecoration('Contrasena', Icons.lock_outline).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: Colors.cyanAccent.withOpacity(0.7),
                              ),
                              onPressed: () => setState(() => _showPassword = !_showPassword),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Ingresa una contrasena';
                            if (value.length < 6) return 'Minimo 6 caracteres';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Confirmar contrasena
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: !_showConfirmPassword,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                          decoration: _inputDecoration('Confirmar contrasena', Icons.lock_outline).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: Colors.cyanAccent.withOpacity(0.7),
                              ),
                              onPressed: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Confirma tu contrasena';
                            if (value != _passwordController.text) return 'Las contrasenas no coinciden';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Modo Offline
                        SwitchListTile(
                          title: const Text(
                            'Modo Offline',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                          ),
                          subtitle: Text(
                            'Juega localmente guardando el progreso en el dispositivo',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                          ),
                          secondary: const Icon(Icons.cloud_off_rounded, color: Colors.cyanAccent),
                          value: _isOffline,
                          onChanged: (bool value) => setState(() => _isOffline = value),
                        ),
                        const SizedBox(height: 30),

                        GameButton(
                          backgroundColor: const Color(0xFF58CC02),
                          shadowColor: const Color(0xFF46A302),
                          onTap: _isLoading ? null : _intentarRegistro,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Text(
                                  'Comenzar Aventura!',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Link a Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ya tienes cuenta? ',
                        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        ),
                        child: const Text(
                          'Iniciar sesion',
                          style: TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.cyanAccent,
                          ),
                        ),
                      ),
                    ],
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
      labelStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w500),
      prefixIcon: Icon(icon, color: Colors.cyanAccent.withOpacity(0.7)),
      filled: true,
      fillColor: Colors.black.withOpacity(0.2),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}