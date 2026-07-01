import 'package:flutter/material.dart';
import '../../../controllers/user_controller.dart';
import '../../widgets/game_button.dart';
import '../../widgets/game_bottom_sheet.dart';
import '../../../controllers/base_level_controller.dart';
import '../../../models/level_model.dart';

class BaseGameplayScreen<T extends LevelModel, C extends BaseLevelController<T>> extends StatefulWidget {
  final int nivel;
  final C Function(BuildContext context) controllerFactory;
  final Widget Function(BuildContext context, C controller) gameFieldBuilder;
  final Widget Function(BuildContext context, C controller)? instructionCardBuilder;

  const BaseGameplayScreen({
    super.key,
    required this.nivel,
    required this.controllerFactory,
    required this.gameFieldBuilder,
    this.instructionCardBuilder,
  });

  @override
  State<BaseGameplayScreen<T, C>> createState() => _BaseGameplayScreenState<T, C>();
}

class _BaseGameplayScreenState<T extends LevelModel, C extends BaseLevelController<T>> extends State<BaseGameplayScreen<T, C>> {
  late C _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controllerFactory(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _comprobar() {
    final bool correcto = _controller.comprobarResultado();
    if (correcto) {
      UserController().completarNivel(widget.nivel);
      GameBottomSheet.mostrarVictoria(
        context: context,
        pigmentosGanados: 30,
        onContinuar: () {
          Navigator.pop(context);
        },
      );
    } else {
      UserController().restarVida();
      final livesLeft = UserController().currentUser.lives;

      String mensajeError = "Esa no es la respuesta correcta. ¡Inténtalo de nuevo!";
      if (_controller.datosNivel is ContrastLevelModel) {
        mensajeError = (_controller.datosNivel as ContrastLevelModel).explanation;
      }

      GameBottomSheet.mostrarDerrota(
        context: context,
        mensaje: livesLeft <= 0
            ? "Te has quedado sin vidas. ¡Repón vidas en el mapa!"
            : mensajeError,
        onReintentar: () {
          if (livesLeft <= 0) {
            Navigator.pop(context);
          } else {
            setState(() {
              _controller = widget.controllerFactory(context);
            });
          }
        },
        onVolver: () {
          Navigator.pop(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double ancho = MediaQuery.of(context).size.width;
    final bool esPantallaAncha = ancho > 600;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        final datos = _controller.datosNivel;

        return Scaffold(
          backgroundColor: const Color(0xFF1E2638), // Fondo oscuro sólido
          appBar: AppBar(
            title: Text('${datos.title} - Nivel ${datos.level}'),
            backgroundColor: const Color(0xFF141824),
            elevation: 0,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Flex(
                    direction: esPantallaAncha ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Lado izquierdo: Instrucciones / Contexto
                      SizedBox(
                        width: esPantallaAncha ? ancho * 0.45 : double.infinity,
                        child: widget.instructionCardBuilder != null
                            ? widget.instructionCardBuilder!(context, _controller)
                            : _buildDefaultInstructionCard(datos),
                      ),
                      const SizedBox(height: 24, width: 24),

                      // Lado derecho: Área interactiva del nivel específico
                      SizedBox(
                        width: esPantallaAncha ? ancho * 0.45 : double.infinity,
                        child: widget.gameFieldBuilder(context, _controller),
                      ),
                    ],
                  ),
                ),
              ),

              // Botón de Comprobación inferior unificado
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: const BoxDecoration(
                  color: Color(0xFF141824),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SafeArea(
                  child: GameButton(
                    backgroundColor: _controller.listoParaComprobar
                        ? const Color(0xFF58CC02)
                        : Colors.grey.shade600,
                    shadowColor: _controller.listoParaComprobar
                        ? const Color(0xFF46A302)
                        : Colors.grey.shade800,
                    enabled: _controller.listoParaComprobar,
                    onTap: _comprobar,
                    child: const Text(
                      "COMPROBAR",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDefaultInstructionCard(LevelModel datos) {
    String subtitle = "";
    String title = datos.title;

    if (datos is MixLevelModel) {
      subtitle = datos.objective;
      title = "OBJETIVO";
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C3545),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF3F4B62), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFFFF9F1C),
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 1.0,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Text(
            datos.instruction,
            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }
}
