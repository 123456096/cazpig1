import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // Para detectar kDebugMode
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../controllers/user_controller.dart';
import '../../services/logging_service.dart'; // Monitoreo A09
import 'menu_principal_screen.dart';
﻿import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../controllers/user_controller.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../widgets/game_button.dart';
import 'menu_principal_screen.dart';
import 'registro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// CORREGIDO: Se quitó la palabra "Is" que causaba el fallo de compilación
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final authService = AuthService();
      final UserCredential cred = await authService
          .signInWithEmailAndPassword(email: _emailCtrl.text, password: _passCtrl.text);

      final user = cred.user;

      // VALIDACIÓN DE SEGURIDAD CRÍTICA (OWASP A07):
      // Si el correo no está verificado Y NO estamos en modo de desarrollo local...
      if (user != null && !user.emailVerified && !kDebugMode) {
        // Revocamos inmediatamente la sesión en el servidor
        await authService.signOut();
        
        // Registramos un evento de alerta en el monitoreo centralizado (OWASP A09)
        await LoggingService.logSecurityEvent(
          nombreEvento: 'acceso_bloqueado_sin_verificar',
          descripcion: 'El usuario ${_emailCtrl.text} intentó entrar sin verificación.',
          detalles: {'user_email': _emailCtrl.text},
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, verifica tu correo electrónico antes de iniciar sesión. Revisa tu bandeja de entrada.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final email = user?.email ?? '';
      String age = '0';

      if (email.isNotEmpty) {
        final db = DatabaseService();
        final profile = await db.getUserProfile(email.replaceAll('.', '_'));
        if (profile != null) {
          await UserController().inicializarDesdePerfil(profile);
        } else {
          UserController().inicializarUsuario(email: email, age: age, isOffline: false);
        }
      } else {
        UserController().inicializarUsuario(email: email, age: age, isOffline: false);
      }
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _showPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _intentarLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await _authService.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      final user = FirebaseAuth.instance.currentUser;
      final email = user?.email ?? _emailController.text;

      await UserController().cargarProgresoLocal();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MenuPrincipalScreen(correo: email, edad: age)),
      );
    } on FirebaseAuthException catch (e, stack) {
      // Monitoreo OWASP A09: Captura intentos fallidos
      if (e.code == 'wrong-password' || e.code == 'user-not-found' || e.code == 'invalid-credential') {
        await LoggingService.logSecurityEvent(
          nombreEvento: 'intento_login_fallido',
          descripcion: 'Credenciales incorrectas para el correo ${_emailCtrl.text}',
          detalles: {'user_email': _emailCtrl.text, 'error_code': e.code},
        );
      } else {
        await LoggingService.logException(e, stack, reason: 'Excepción de autenticación en Login Screen');
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AuthService().getErrorMessage(e))));
    } catch (e, stack) {
      await LoggingService.logException(e, stack, reason: 'Error crítico genérico en flujo de Login');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al iniciar sesión')));
    } finally {
      if (mounted) setState(() => _loading = false);
        MaterialPageRoute(
          builder: (context) => MenuPrincipalScreen(
            correo: email,
            edad: UserController().currentUser.age,
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
        const SnackBar(content: Text('No se pudo iniciar sesion. Intenta de nuevo.')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Correo'),
                validator: (v) => v == null || v.isEmpty ? 'Ingresa tu correo' : null,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passCtrl,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (v) => v == null || v.isEmpty ? 'Ingresa tu contraseña' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _login,
                child: _loading ? const CircularProgressIndicator() : const Text('Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
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
                      "Bienvenido de vuelta",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Continua tu aventura de colores",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
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
                        const Icon(Icons.emoji_events_outlined, size: 50, color: Colors.cyanAccent),
                        const SizedBox(height: 24),

                        // Correo
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                          decoration: _inputDecoration('Correo Electronico', Icons.email_outlined),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Ingresa tu correo';
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Correo invalido';
                            return null;
                          },
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
                            if (value == null || value.isEmpty) return 'Ingresa tu contrasena';
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        GameButton(
                          backgroundColor: const Color(0xFF6C5CE7),
                          shadowColor: const Color(0xFF4A3DB5),
                          onTap: _isLoading ? null : _intentarLogin,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Text(
                                  'Iniciar Sesion',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Link a Registro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No tienes cuenta? ',
                        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const RegistroScreen()),
                        ),
                        child: const Text(
                          'Registrate',
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
