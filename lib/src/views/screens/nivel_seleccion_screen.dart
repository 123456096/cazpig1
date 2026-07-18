import 'package:flutter/material.dart';
import 'dart:math';
import '../../controllers/user_controller.dart';
import '../widgets/game_button.dart';
import '../widgets/app_navigation_bar.dart'; // Asegúrate de que este import coincida con la ruta de tu barra
import 'gameplay/nivel1_screen.dart';
import 'gameplay/nivel2_screen.dart';
import 'gameplay/nivel3_screen.dart';
import 'gameplay/nivel4_screen.dart';
import 'gameplay/nivel5_screen.dart';
import 'gameplay/nivel6_screen.dart';
import 'gameplay/nivel7_screen.dart';
import 'gameplay/nivel8_screen.dart';
import 'gameplay/nivel9_screen.dart';
import 'gameplay/nivel10_screen.dart';
import 'gameplay/nivel11_screen.dart';
import 'gameplay/nivel12_screen.dart';

class NivelSeleccionScreen extends StatefulWidget {
  const NivelSeleccionScreen({super.key});

  @override
  State<NivelSeleccionScreen> createState() => _NivelSeleccionScreenState();
}

class _NivelSeleccionScreenState extends State<NivelSeleccionScreen> {
  final UserController _userController = UserController();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // Calcular en qué fila está el nivel actual
    final activeLevel = _userController.currentUser.currentLevelReached;
    final double initialOffset = max(0.0, (activeLevel - 2) * 190.0);
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
  }

  // Función matemática para saber en qué fila cae un nivel (patrón 1-2-1-2)
  int _getRowForLevel(int level) {
    if (level <= 0) return 0;
    int blocks = (level - 1) ~/ 3;
    int remainder = (level - 1) % 3;
    return (blocks * 2) + (remainder == 0 ? 0 : 1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _userController,
      builder: (context, child) {
        final currentLevel = _userController.currentUser.currentLevelReached;

        return Stack(
          children: [
            // 1. FONDO (Solo la imagen pergamino)
            Positioned.fill(
              child: Image.asset(
                'assets/imagenes/fondo.jpeg',
                fit:BoxFit.cover,
              ),
            const Positioned.fill(
              child: AnimatedBackground(child: SizedBox.shrink()),
            ),
            
            // 2. LA PANTALLA
            Scaffold(
              backgroundColor: Colors.transparent,
              extendBody: true, // Hace que los niveles pasen por detrás elegantemente
              
              // 👈 AQUÍ SE QUEDA LA BARRA FIXA ABAJO
              bottomNavigationBar: AppNavigationBar(
                currentIndex: 1,
                onTap: (index) {
                  print("Click en pestaña: $index");
                },
              ),
              
              body: LayoutBuilder(
                builder: (context, constraints) {
                  final double screenWidth = constraints.maxWidth;

                  double getXOffset(int index) {
                    return screenWidth / 2 + sin(index * 0.8) * (screenWidth * 0.23);
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(bottom: 140), // Espacio para que el nivel 100 no quede tapado
                    itemCount: 101,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildSectionHeader(); // Tu Header superior normal
                      }

                      final levelNumber = index; // Nivel 1 a 100
                      final isCompleted = levelNumber < currentLevel;
                      final isActive = levelNumber == currentLevel;
                      final isLocked = levelNumber > currentLevel;
                      final bool isChest = levelNumber % 5 == 0; // Cada 5 niveles hay un cofre de regalo

                      // Determinar el color base según el tipo de nivel
                      final int levelType = levelNumber % 3;
                      Color levelColor = Colors.teal;
                      Color levelShadow = Colors.teal.shade800;

                      if (levelType == 1) {
                        levelColor = const Color(0xFF00C897); // Verde azulado brillante
                        levelShadow = const Color(0xFF009673);
                      } else if (levelType == 2) {
                        levelColor = const Color(0xFFFF9F1C); // Naranja brillante
                        levelShadow = const Color(0xFFCC7F16);
                      } else {
                        levelColor = const Color(0xFF9B5DE5); // Morado neón
                        levelShadow = const Color(0xFF7B4AB5);
                      }

                      if (isChest) {
                        levelColor = const Color(0xFFFFD166); // Oro/Dorado para el cofre
                        levelShadow = const Color(0xFFD4AA3F);
                      }

                      // Si está completado, color verde esmeralda brillante
                      if (isCompleted && !isChest) {
                        levelColor = const Color(0xFF58CC02);
                        levelShadow = const Color(0xFF46A302);
                      }

                      // Si está bloqueado, color gris
                      if (isLocked) {
                        levelColor = const Color(0xFF4E586E);
                        levelShadow = const Color(0xFF343B4A);
                      }

                      final double currentX = getXOffset(levelNumber);

                      return SizedBox(
                        height: 190, // Altura uniforme controlada para evitar cortes
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Elemento interactivo en 3D (Nivel o Cofre)
                            Positioned(
                              left: currentX - 40, // Centrado para un botón de 80px de ancho
                              top: 25,
                              child: Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  // Estructura Neumórfica 3D (Estilo Duolingo/Gaming)
                                  SizedBox(
                                    width: 80,
                                    height: 86,
                                    child: Stack(
                                      children: [
                                        // Capa Inferior (Sombra tridimensional del botón)
                                        Positioned(
                                          bottom: 0,
                                          child: Container(
                                            width: 80,
                                            height: 76,
                                            decoration: BoxDecoration(
                                              color: levelShadow,
                                              shape: isChest ? BoxShape.rectangle : BoxShape.circle,
                                              borderRadius: isChest ? BorderRadius.circular(20) : null,
                                            ),
                                          ),
                                        ),
                                        // Capa Superior (El frente interactivo del botón)
                                        Positioned(
                                          top: 0,
                                          child: GameButton(
                                            width: 80,
                                            height: 76,
                                            borderRadius: isChest ? 20 : 38,
                                            backgroundColor: levelColor,
                                            shadowColor: Colors.transparent, // Anulamos sombra nativa
                                            onTap: isChest 
                                                ? () => _abrirCofre(context, levelNumber) 
                                                : () => _iniciarDesafiodeNivel(context, levelNumber),
                                            enabled: !isLocked,
                                            child: isChest
                                                ? Icon(
                                                    isCompleted ? Icons.drafts_outlined : Icons.inventory_2_outlined,
                                                    color: isLocked ? Colors.white60 : const Color(0xFF191D2B),
                                                    size: 32,
                                                  )
                                                : Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      gradient: RadialGradient(
                                                        colors: isLocked
                                                            ? [const Color(0xFF5A667D), const Color(0xFF343B4A)]
                                                            : [levelColor.withOpacity(0.4), levelColor],
                                                        center: const Alignment(0.0, -0.2),
                                                        radius: 0.8,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        '$levelNumber',
                                                        style: const TextStyle(
                                                          fontSize: 26,
                                                          fontWeight: FontWeight.w900,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Tooltip flotante encima si es el nivel activo
                                  if (isActive)
                                    const Positioned(
                                      top: -45,
                                      child: FloatingTooltip(),
                                    ),

                                  // Tres estrellas debajo del nivel
                                  if (!isChest)
                                    Positioned(
                                      bottom: -22,
                                      child: _buildStars(isCompleted),
                                    ),

                                  // Checkmark si está completado
                                  if (isCompleted && !isChest)
                                    const Positioned(
                                      bottom: 5,
                                      right: -2,
                                      child: CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Color(0xFF58CC02), // Verde vibrante
                                        child: Icon(
                                          Icons.check,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

 Widget _buildSectionHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00C897), Color(0xFF009673)], 
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:const EdgeInsets.symmetric(horizontal:10,vertical:4),
                   decoration:BoxDecoration(
                    color:const Color(0xFFFFD166).withOpacity(0.2),
                    borderRadius:BorderRadius.circular(10),
                  ),
               child:const Text(
                  "SECCIÓN 1 · UNIDAD 1",
                  style: TextStyle(
                    color: Colors.white70, // 👈 Corregido aquí (blanco con 70% opacidad)
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Ruta de los Pigmentos",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Supera mezclas, branding y degradados infinitos para coronarte maestro.",
                  style: TextStyle(
                    color: Colors.white, // 👈 Corregido aquí (blanco sólido)
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Icon(Icons.palette_rounded, color: Colors.white, size: 45),
        ],
      ),
    );
  }

  Widget _buildStars(bool isCompleted) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (starIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: Icon(
            Icons.star,
            size: 14,
            color: isCompleted ? const Color(0xFFFFD60A) : const Color(0xFF343B4A),
          ),
        );
      }),
    );
  }

  void _iniciarDesafiodeNivel(BuildContext context, int nivel) {
    if (_userController.currentUser.lives <= 0) {
      _mostrarCompraVidasDialog(context);
      return;
    }

    Widget pantallaDestino;
    int tipo = nivel % 12;

    if (tipo == 1) {
      pantallaDestino = Nivel1Screen(nivelInicial: nivel);
    } else if (tipo == 2) {
      pantallaDestino = Nivel2Screen(nivelInicial: nivel);
    } else if (tipo == 3) {
      pantallaDestino = Nivel3Screen(nivelInicial: nivel);
    } else if (tipo == 4) {
      pantallaDestino = Nivel4Screen(nivelInicial: nivel);
    } else if (tipo == 5) {
      pantallaDestino = Nivel5Screen(nivelInicial: nivel);
    } else if (tipo == 6) {
      pantallaDestino = Nivel6Screen(nivelInicial: nivel);
    } else if (tipo == 7) {
      pantallaDestino = Nivel7Screen(nivelInicial: nivel);
    } else if (tipo == 8) {
      pantallaDestino = Nivel8Screen(nivelInicial: nivel);
    } else if (tipo == 9) {
      pantallaDestino = Nivel9Screen(nivelInicial: nivel);
    } else if (tipo == 10) {
      pantallaDestino = Nivel10Screen(nivelInicial: nivel);
    } else if (tipo == 11) {
      pantallaDestino = Nivel11Screen(nivelInicial: nivel);
    } else {
      pantallaDestino = Nivel12Screen(nivelInicial: nivel);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => pantallaDestino),
    ).then((_) {
      _userController.verificarYRegenerarVidas();
    });
  }

  void _mostrarCompraVidasDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: const Text(
          "❤️ Sin Vidas",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_rounded, color: Color(0xFFFF4B4B), size: 70),
            SizedBox(height: 16),
            Text(
              "No tienes vidas suficientes para jugar. ¿Quieres reponer tus 5 vidas de inmediato?",
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
              bool exito = _userController.comprarVidasConPigmentos();
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

  void _abrirCofre(BuildContext context, int nivel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: const Color(0xFF1E2638),
        title: const Text(
          "🎁 Cofre de Recompensa",
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFFFFD166), fontWeight: FontWeight.bold, fontSize: 22),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.redeem_rounded, color: Color(0xFFFFD166), size: 80),
            const SizedBox(height: 16),
            const Text(
              "¡Has alcanzado y abierto un cofre en tu camino cromático!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "+150 XP y +50 Pigmentos",
                style: TextStyle(color: Color(0xFF00C897), fontSize: 18, fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                _userController.completarNivel(nivel);
                Navigator.pop(context);
              },
              child: const Text(
                "¡Recibir Recompensa!",
                style: TextStyle(color: Color(0xFFFFD166), fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ==================== COMPONENTE: TOOLTIP FLOTANTE ANIMADO ====================
class FloatingTooltip extends StatefulWidget {
  const FloatingTooltip({super.key});

  @override
  State<FloatingTooltip> createState() => _FloatingTooltipState();
}

class _FloatingTooltipState extends State<FloatingTooltip> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_controller.value * 6),
          child: child,
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Text(
              "¡JUGAR!",
              style: TextStyle(
                color: Color(0xFF191D2B),
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
          CustomPaint(
            size: const Size(12, 6),
            painter: TrianglePainter(),
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TrianglePainter oldDelegate) => false;
} 
