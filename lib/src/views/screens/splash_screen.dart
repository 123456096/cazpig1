import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../controllers/splash_controller.dart';
import '../../controllers/user_controller.dart';
import '../../theme/app_theme.dart';
import 'registro_screen.dart';
import 'menu_principal_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController _controller = SplashController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // Cargar progreso persistido antes de completar la simulación de carga
        await UserController().cargarProgresoLocal();
      } catch (e) {
        debugPrint("Error al cargar SharedPreferences: $e");
      }

      _controller.iniciarSimulacionDeCarga(
        onComplete: () {
          final user = UserController().currentUser;
          // Si el correo no es el por defecto (invitado), significa que ya se registró anteriormente
          final bool yaRegistrado = user.email != "invitado@correo.com";

          if (yaRegistrado) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MenuPrincipalScreen(
                  correo: user.email,
                  edad: user.age,
                ),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RegistroScreen()),
            );
          }
        },
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF191D2B), // Fondo oscuro de juego unificado
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            int porcentaje = (_controller.progreso * 100).toInt();
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Título del Juego con brillo de neón degradado
                    ShaderMask(
                      shaderCallback: (bounds) => AppTheme.degradadoGlow.createShader(bounds),
                      child: const Text(
                        "CAZADORES DE PIGMENTOS",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Spinner Lottie interactivo central
                    Lottie.asset(
                      'assets/spinners/spinner.json',
                      width: 160,
                      height: 160,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const CircularProgressIndicator(color: Color(0xFF00C897));
                      },
                    ),
                    const SizedBox(height: 48),

                    // Mensaje de carga interactivo
                    Text(
                      _controller.mensaje,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Porcentaje en color neón
                    Text(
                      '$porcentaje%',
                      style: const TextStyle(
                        color: Color(0xFFFF9F1C),
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
