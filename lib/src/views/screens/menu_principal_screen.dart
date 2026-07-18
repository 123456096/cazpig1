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

            // Si es Perfil o Ajustes, pintamos su barra superior premium simulada
            if (_currentIndex != 1)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildBarraAlternativa(),
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

  // Estructura limpia para las otras dos pantallas (Perfil y Ajustes)
  Widget _buildBarraAlternativa() {
    String titulo = _currentIndex == 2 ? "Ajustes de Juego" : "Cazadores de Pigmentos";
    
    return Container(
      height: 60,
      color: const Color.fromARGB(255, 18, 17, 17),
      alignment: Alignment.center,
      child: SafeArea(
        bottom: false,
        child: ShaderMask(
          shaderCallback: (bounds) => AppTheme.degradadoGlow.createShader(bounds),
          child: Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}