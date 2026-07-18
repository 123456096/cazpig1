import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 18, 17, 17),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: FondoLiquidoAnimadoPainter(_controller.value),
            child: widget.child,
          );
        },
      ),
    );
  }
}

class FondoLiquidoAnimadoPainter extends CustomPainter {
  final double progress;
  FondoLiquidoAnimadoPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    void dibujarParticula(double basePctX, double basePctY, double radio, Color color, double speed, double phase, [double glowSpread = 3.0]) {
      double time = progress * 2 * math.pi;
      
      // Movimiento de flotación vertical y oscilación horizontal
      double x = size.width * (basePctX + 0.04 * math.sin(time * speed + phase));
      double y = size.height * ((basePctY - progress * speed * 0.15 + phase) % 1.0);
      
      final paintGlow = Paint()
        ..color = color.withOpacity(0.3)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowSpread);
      
      final paintCore = Paint()..color = color.withOpacity(0.8);
      
      canvas.drawCircle(Offset(x, y), radio + glowSpread, paintGlow);
      canvas.drawCircle(Offset(x, y), radio, paintCore);
    }

    // Cian
    dibujarParticula(0.15, 0.10, 4.0, Colors.cyanAccent, 1.0, 0.0);
    dibujarParticula(0.85, 0.25, 2.5, Colors.cyan, 1.5, 1.0);
    dibujarParticula(0.50, 0.90, 3.5, Colors.cyanAccent, 0.8, 2.0);
    dibujarParticula(0.10, 0.60, 2.0, const Color(0xFF00C8D2), 1.2, 3.0);

    // Ámbar
    dibujarParticula(0.75, 0.70, 5.0, Colors.amber, 0.9, 4.0, 8.0);
    dibujarParticula(0.35, 0.40, 2.0, Colors.amberAccent, 1.4, 5.0);
    dibujarParticula(0.90, 0.85, 3.0, Colors.orangeAccent, 1.1, 0.5);
    dibujarParticula(0.45, 0.15, 2.0, Colors.amber, 0.7, 1.5);

    // Rosa
    dibujarParticula(0.20, 0.80, 4.5, Colors.pinkAccent, 1.0, 2.5);
    dibujarParticula(0.80, 0.15, 3.0, const Color(0xFFD63384), 1.3, 3.5);
    dibujarParticula(0.65, 0.55, 2.5, Colors.pink, 0.9, 0.8);
    dibujarParticula(0.30, 0.90, 1.5, Colors.pinkAccent, 1.5, 1.8);

    // Púrpura
    dibujarParticula(0.55, 0.30, 4.0, Colors.deepPurpleAccent, 1.1, 2.2);
    dibujarParticula(0.05, 0.35, 3.0, Colors.purpleAccent, 0.8, 3.1);
    dibujarParticula(0.70, 0.95, 2.0, Colors.purple, 1.4, 0.2);

    // Polvo blanco
    dibujarParticula(0.40, 0.75, 1.0, Colors.white, 0.6, 1.1, 2.0);
    dibujarParticula(0.60, 0.10, 1.0, Colors.white70, 0.8, 2.3, 2.0);
    dibujarParticula(0.25, 0.25, 1.2, Colors.white60, 0.5, 0.7, 2.0);
    dibujarParticula(0.85, 0.50, 1.0, Colors.white, 0.7, 1.9, 2.0);
  }

  @override
  bool shouldRepaint(covariant FondoLiquidoAnimadoPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
