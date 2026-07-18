import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 95, // Altura fija perfecta para que se vea el "buen pedazo" de arriba
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/imagenes/fondo_barra.png'),
          fit: BoxFit.fitWidth, // Se estira a lo ancho exactamente igual que el header
          alignment: Alignment.bottomCenter,
        ),
      ),
      // Tres áreas invisibles exactas para los clicks
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(index),
              child: const SizedBox.expand(),
            ),
          );
        }),
      ),
    );
  }
}