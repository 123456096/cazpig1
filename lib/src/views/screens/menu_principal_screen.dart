import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../widgets/app_navigation_bar.dart';
import '../widgets/progress_header.dart';
import 'perfil_screen.dart';
import 'nivel_seleccion_screen.dart';
import 'ajustes_screen.dart';

class MenuPrincipalScreen extends StatefulWidget {
  final String correo;
  final String edad;

  const MenuPrincipalScreen({
    super.key,
    required this.correo,
    required this.edad,
  });

  @override
  State<MenuPrincipalScreen> createState() => _MenuPrincipalScreenState();
}

class _MenuPrincipalScreenState extends State<MenuPrincipalScreen> {
  int _currentIndex = 1; // Inicia en 'Jugar'
  late List<Widget> _paginas;

  @override
  void initState() {
    super.initState();
    _paginas = [
      PerfilScreen(correo: widget.correo, edad: widget.edad),
      const NivelSeleccionScreen(),  
      const AjustesScreen(),   
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF191D2B),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true, // 👈 Dejamos solo este, que es el correcto
        
        // Colocamos un Stack en el body para encimar el Header de forma limpia
        body: Stack(
          children: [
            // La pantalla activa (El mapa o lo que corresponda)
            Positioned.fill(
              child: _paginas[_currentIndex],
            ),
            
            // Si estamos en la pestaña del mapa (1), encimamos el ProgressHeader flotando libre
            if (_currentIndex == 1)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ProgressHeader(),
              ),

          ],
        ),
        bottomNavigationBar: AppNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }

}