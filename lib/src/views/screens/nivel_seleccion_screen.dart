import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui' as ui;
import '../../controllers/user_controller.dart';
import '../widgets/app_navigation_bar.dart';
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

// ─── Constantes globales de layout ──────────────────────────────────────────
const int    _kTotalLevels  = 100;
const double _kRowHeight    = 150.0;  // Espacio vertical entre filas
const double _kSealSize     = 90.0;   // Tamaño del sello de cera
const double _kHeaderHeight = 170.0;  // Alto reservado para el header

/// Retorna el índice de fila (1-based) correspondiente a un nivel.
int _getRowForLevel(int level) {
  int group = (level - 1) ~/ 3;
  int rem = (level - 1) % 3;
  return group * 2 + (rem == 0 ? 1 : 2);
}

/// Retorna la cantidad total de filas necesarias para todos los niveles
int _getTotalRows(int totalLevels) {
  return _getRowForLevel(totalLevels);
}

/// Retorna la coordenada X del centro del nodo del nivel
double _nodeX(int level, double screenWidth) {
  int rem = (level - 1) % 3;
  final double center = screenWidth * 0.5;
  final double amp = screenWidth * 0.28;
  if (rem == 0) return center;
  if (rem == 1) return center - amp;
  return center + amp;
}

/// Retorna la coordenada Y del centro del nodo del nivel
double _nodeY(int level) {
  int row = _getRowForLevel(level);
  return _kHeaderHeight + (row - 0.5) * _kRowHeight;
}

/// Retorna la coordenada X de la hebra (izquierda o derecha) en una fila dada
double _strandX(int row, bool isLeft, double screenWidth) {
  final double center = screenWidth * 0.5;
  final double amp = screenWidth * 0.28;
  if (row % 2 == 1) {
    return center; 
  } else {
    return isLeft ? (center - amp) : (center + amp); 
  }
}

/// Retorna la coordenada Y del centro de una fila dada
double _rowY(int row) {
  return _kHeaderHeight + (row - 0.5) * _kRowHeight;
}

// ─────────────────────────────────────────────────────────────────────────────
class NivelSeleccionScreen extends StatefulWidget {
  const NivelSeleccionScreen({super.key});

  @override
  State<NivelSeleccionScreen> createState() => _NivelSeleccionScreenState();
}

class _NivelSeleccionScreenState extends State<NivelSeleccionScreen>
    with SingleTickerProviderStateMixin {
  final UserController _userController = UserController();
  late ScrollController _scrollController;
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    final int active = _userController.currentUser.currentLevelReached;
    final int activeRow = _getRowForLevel(active);
    final double initialOffset =
        max(0.0, _kHeaderHeight + (activeRow - 3) * _kRowHeight);
    _scrollController = ScrollController(initialScrollOffset: initialOffset);

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _userController,
      builder: (context, _) {
        final int currentLevel =
            _userController.currentUser.currentLevelReached;
        final int totalRows = _getTotalRows(_kTotalLevels);

        return Stack(
          children: [
            // ── 1. Fondo pergamino (Completo de borde a borde) ──────────────
            Positioned.fill(
              child: Image.asset(
                'assets/imagenes/fondo.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF2B1A0A).withOpacity(0.50),
                      const Color(0xFF1A1000).withOpacity(0.30),
                      const Color(0xFF2B1A0A).withOpacity(0.55),
                    ],
                  ),
                ),
              ),
            ),

            // ── 2. Scaffold con el mapa protegido por SafeArea ──────────────
            Scaffold(
              backgroundColor: Colors.transparent,
              extendBody: true,
              bottomNavigationBar: AppNavigationBar(
                currentIndex: 1,
                onTap: (_) {},
              ),
              // El SafeArea envuelve el body completo para proteger la zona superior e inferior
              body: SafeArea(
                top: true,
                bottom: true,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double sw = constraints.maxWidth;
                    // Se añade un margen extra abajo para que la barra de navegación no pise los últimos niveles
                    final double totalH =
                        _kHeaderHeight + (totalRows + 1) * _kRowHeight + 220;

                    return SingleChildScrollView(
                      controller: _scrollController,
                      child: SizedBox(
                        width: sw,
                        height: totalH,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // ── Camino sinuoso punteado ──
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _PathPainter(
                                  screenWidth: sw,
                                  currentLevel: currentLevel,
                                  totalRows: totalRows,
                                ),
                              ),
                            ),

                            // ── Header de sección ──
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: _buildSectionHeader(),
                            ),

                            // ── Nodos de nivel ──
                            for (int lvl = 1; lvl <= _kTotalLevels; lvl++)
                              ..._buildSealNode(
                                context: context,
                                level: lvl,
                                currentLevel: currentLevel,
                                screenWidth: sw,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Header de sección ──────────────────────────────────────────────────────
  Widget _buildSectionHeader() {
    return Container(
      // Reducido el margen superior de 52 a 12 porque el SafeArea ya añade la separación del notch
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2B1A).withOpacity(0.88),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFD4A017).withOpacity(0.72),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4A017).withOpacity(0.28),
            blurRadius: 22,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4A017).withOpacity(0.22),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: const Color(0xFFD4A017).withOpacity(0.58)),
                  ),
                  child: const Text(
                    "⚓  MAPA · RUTA 1",
                    style: TextStyle(
                      color: Color(0xFFFFD166),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Ruta de los Pigmentos",
                  style: TextStyle(
                    color: Color(0xFFF5E6C8),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Supera mezclas, branding y degradados para coronarte maestro.",
                  style: TextStyle(
                    color: const Color(0xFFD4B896).withOpacity(0.88),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Stack(
            alignment: Alignment.center,
            children: [
              ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Color(0xFFD4A017),
                  BlendMode.modulate,
                ),
                child: Image.asset(
                  'assets/imagenes/sello.png',
                  width: 64,
                  height: 64,
                  fit: BoxFit.contain,
                ),
              ),
              const Icon(Icons.explore_rounded,
                  color: Colors.white, size: 26),
            ],
          ),
        ],
      ),
    );
  }

  // ── Nodo de nivel ──────────────────────────────────────────────────────────
  List<Widget> _buildSealNode({
    required BuildContext context,
    required int level,
    required int currentLevel,
    required double screenWidth,
  }) {
    final bool isCompleted = level < currentLevel;
    final bool isActive    = level == currentLevel;
    final bool isLocked    = level > currentLevel;
    final bool isChest     = level % 5 == 0;

    Color sealColor;
    if (isLocked) {
      sealColor = const Color(0xFF4A5268);
    } else if (isChest) {
      sealColor = const Color(0xFFD4A017);
    } else if (isCompleted) {
      final shades = [
        const Color(0xFF7B5E3A),
        const Color(0xFF3A7B6F),
        const Color(0xFF7B3A4F),
        const Color(0xFF3A4F7B),
      ];
      sealColor = shades[level % shades.length];
    } else {
      sealColor = const Color(0xFFC8860A); 
    }

    Widget sealContent;
    if (isChest) {
      sealContent = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompleted ? Icons.drafts_outlined : Icons.inventory_2_outlined,
            color: isLocked ? Colors.white38 : Colors.white,
            size: 28,
          ),
          const SizedBox(height: 2),
          Text(
            '$level',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: isLocked ? Colors.white38 : Colors.white,
              shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
            ),
          ),
        ],
      );
    } else {
      sealContent = Text(
        '$level',
        style: TextStyle(
          fontSize: level >= 100 ? 26 : 32,
          fontWeight: FontWeight.w900,
          color: isLocked ? Colors.white38 : Colors.white,
          shadows: const [
            Shadow(color: Colors.black54, blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
      );
    }

    Widget sealWidget = Stack(
      alignment: Alignment.center,
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(sealColor, BlendMode.modulate),
          child: Image.asset(
            'assets/imagenes/sello.png',
            width: _kSealSize,
            height: _kSealSize,
            fit: BoxFit.contain,
          ),
        ),
        sealContent,
      ],
    );

    if (isActive) {
      sealWidget = AnimatedBuilder(
        animation: _pulseCtrl,
        builder: (_, child) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD166)
                    .withOpacity(0.5 + _pulseCtrl.value * 0.3),
                blurRadius: 18 + _pulseCtrl.value * 20,
                spreadRadius: 4 + _pulseCtrl.value * 10,
              ),
            ],
          ),
          child: child,
        ),
        child: sealWidget,
      );
    }

    final double cx = _nodeX(level, screenWidth);
    final double cy = _nodeY(level);
    const double half = _kSealSize / 2;
    final double rotationAngle = sin(level * 1.5) * 0.15; 

    return [
      if (isActive)
        Positioned(
          left: cx - 55,
          top: cy - half - 48,
          width: 110,
          child: const FloatingTooltip(),
        ),

      Positioned(
        left: cx - half,
        top: cy - half,
        width: _kSealSize,
        height: _kSealSize,
        child: Transform.rotate(
          angle: rotationAngle,
          child: GestureDetector(
            onTap: isLocked
                ? null
                : (isChest
                    ? () => _abrirCofre(context, level)
                    : () => _iniciarDesafiodeNivel(context, level)),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 3,
                  left: 2,
                  child: Opacity(
                    opacity: 0.25,
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                      child: Image.asset(
                        'assets/imagenes/sello.png',
                        width: _kSealSize,
                        height: _kSealSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                sealWidget,

                if (isCompleted && !isChest)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D00),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFF5E6C8), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.35),
                              blurRadius: 4,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: const Icon(Icons.check, size: 13, color: Colors.white),
                    ),
                  ),

                if (isLocked)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C3545),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 1.5),
                      ),
                      child: const Icon(Icons.lock, size: 11, color: Colors.white38),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),

      if (!isChest)
        Positioned(
          left: cx - 28,
          top: cy + half + 4,
          child: _buildStars(isCompleted),
        ),
    ];
  }

  Widget _buildStars(bool isCompleted) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.5),
          child: Icon(
            Icons.star_rounded,
            size: 16,
            color: isCompleted
                ? const Color(0xFFD4A017)
                : const Color(0xFF6B5A45).withOpacity(0.55),
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
    Widget pantalla;
    final int tipo = nivel % 12;
    switch (tipo) {
      case 1:  pantalla = Nivel1Screen(nivelInicial: nivel);  break;
      case 2:  pantalla = Nivel2Screen(nivelInicial: nivel);  break;
      case 3:  pantalla = Nivel3Screen(nivelInicial: nivel);  break;
      case 4:  pantalla = Nivel4Screen(nivelInicial: nivel);  break;
      case 5:  pantalla = Nivel5Screen(nivelInicial: nivel);  break;
      case 6:  pantalla = Nivel6Screen(nivelInicial: nivel);  break;
      case 7:  pantalla = Nivel7Screen(nivelInicial: nivel);  break;
      case 8:  pantalla = Nivel8Screen(nivelInicial: nivel);  break;
      case 9:  pantalla = Nivel9Screen(nivelInicial: nivel);  break;
      case 10: pantalla = Nivel10Screen(nivelInicial: nivel); break;
      case 11: pantalla = Nivel11Screen(nivelInicial: nivel); break;
      default: pantalla = Nivel12Screen(nivelInicial: nivel); break;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => pantalla),
    ).then((_) => _userController.verificarYRegenerarVidas());
  }

  void _mostrarCompraVidasDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: const Color(0xFF1A1000),
        title: const Text("❤️ Sin Vidas",
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_rounded, color: Color(0xFFFF4B4B), size: 70),
            SizedBox(height: 16),
            Text(
              "No tienes vidas suficientes para jugar.\n¿Quieres reponer tus 5 vidas de inmediato?",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 8),
            Text("Coste: 150 💎",
                style: TextStyle(
                    color: Color(0xFF1CB0F6),
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar",
                  style: TextStyle(color: Colors.white60))),
          ElevatedButton(
            onPressed: () {
              bool ok = _userController.comprarVidasConPigmentos();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(ok
                    ? "¡Vidas recargadas al máximo!"
                    : "No tienes suficientes pigmentos 💎"),
                backgroundColor: ok ? Colors.green : Colors.red,
              ));
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF4B4B)),
            child: const Text("Comprar",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
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
        title: const Text("🎁 Cofre de Recompensa",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xFFFFD166),
                fontWeight: FontWeight.bold,
                fontSize: 22)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.redeem_rounded,
                color: Color(0xFFFFD166), size: 80),
            const SizedBox(height: 16),
            const Text(
              "¡Has alcanzado y abierto un cofre en tu camino cromático!",
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 16),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text("+150 XP y +50 Pigmentos",
                  style: TextStyle(
                      color: Color(0xFF00C897),
                      fontSize: 18,
                      fontWeight: FontWeight.w900)),
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
              child: const Text("¡Recibir Recompensa!",
                  style: TextStyle(
                      color: Color(0xFFFFD166),
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}

// ─── CustomPainter ───────────────────────────────────────────────────────────
class _PathPainter extends CustomPainter {
  final double screenWidth;
  final int currentLevel;
  final int totalRows;

  _PathPainter({
    required this.screenWidth,
    required this.currentLevel,
    required this.totalRows,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawStrand(canvas, isLeft: true);
    _drawStrand(canvas, isLeft: false);
  }

  void _drawStrand(Canvas canvas, {required bool isLeft}) {
    final Path path = Path();
    path.moveTo(_strandX(1, isLeft, screenWidth), _rowY(1));

    for (int r = 1; r < totalRows; r++) {
      final double x1 = _strandX(r, isLeft, screenWidth);
      final double y1 = _rowY(r);
      final double x2 = _strandX(r + 1, isLeft, screenWidth);
      final double y2 = _rowY(r + 1);
      final double midY = (y1 + y2) / 2;

      path.cubicTo(x1, midY, x2, midY, x2, y2);
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black.withOpacity(0.25)
        ..strokeWidth = 11
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF2C251C).withOpacity(0.4)
        ..strokeWidth = 9
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    _drawDotsOnPath(canvas, path);
  }

  void _drawDotsOnPath(Canvas canvas, Path path) {
    const double dotR = 4.2;
    const double spacing = 16.0;
    double distance = spacing / 2;

    for (final ui.PathMetric m in path.computeMetrics()) {
      while (distance < m.length) {
        final ui.Tangent? t = m.getTangentForOffset(distance);
        if (t != null) {
          final double currentYLimit = _nodeY(currentLevel);
          final bool unlocked = t.position.dy <= (currentYLimit + 10);

          final Color dotColor = unlocked
              ? const Color(0xFFD4A017)   
              : const Color(0xFF3E485A);  

          canvas.drawCircle(
            t.position + const Offset(0, 1.5),
            dotR,
            Paint()
              ..color = Colors.black.withOpacity(0.35)
              ..style = PaintingStyle.fill,
          );
          canvas.drawCircle(
            t.position,
            dotR,
            Paint()
              ..color = dotColor
              ..style = PaintingStyle.fill,
          );
        }
        distance += spacing;
      }
      distance = spacing / 2;
    }
  }

  @override
  bool shouldRepaint(covariant _PathPainter old) =>
      old.currentLevel != currentLevel || old.screenWidth != screenWidth;
}

// ─── Tooltip flotante animado ─────────────────────────────────────────────────
class FloatingTooltip extends StatefulWidget {
  const FloatingTooltip({super.key});

  @override
  State<FloatingTooltip> createState() => _FloatingTooltipState();
}

class _FloatingTooltipState extends State<FloatingTooltip>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    )..repeat(reverse: true);
    _bounce = Tween<double>(begin: 0, end: -6)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounce,
      builder: (_, child) =>
          Transform.translate(offset: Offset(0, _bounce.value), child: child),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD166),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 3)),
              ],
            ),
            child: const Text(
              "¡JUGAR!",
              style: TextStyle(
                color: Color(0xFF3D2200),
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
          ),
          CustomPaint(
            size: const Size(14, 7),
            painter: _TrianglePainter(),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width / 2, size.height)
        ..lineTo(size.width, 0)
        ..close(),
      Paint()
        ..color = const Color(0xFFFFD166)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter _) => false;
}