import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // Para detectar kDebugMode
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../controllers/user_controller.dart';
import '../../services/logging_service.dart'; // Monitoreo A09
import 'menu_principal_screen.dart';

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