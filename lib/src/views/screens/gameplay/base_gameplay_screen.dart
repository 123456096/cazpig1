import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../controllers/user_controller.dart';
import '../../widgets/game_button.dart';
import '../../widgets/game_bottom_sheet.dart';
import '../../../controllers/base_level_controller.dart';
import '../../../controllers/level_generator.dart';
import '../../../models/level_model.dart';

class BaseGameplayScreen<T extends LevelModel, C extends BaseLevelController<T>> extends StatefulWidget {
  final int nivel;
  final C Function(BuildContext context) controllerFactory;
  final Widget Function(BuildContext context, C controller) gameFieldBuilder;
  final Widget Function(BuildContext context, C controller)? instructionCardBuilder;
  final bool ocultarBotonComprobar; // <--- NUEVA PROPIEDAD CONTROLADORA

  const BaseGameplayScreen({
    super.key,
    required this.nivel,
    required this.controllerFactory,
    required this.gameFieldBuilder,
    this.instructionCardBuilder,
    this.ocultarBotonComprobar = false, // Por defecto se muestra para otros niveles
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
      final String fact = LevelGenerator.obtenerDatoCurioso(_controller.datosNivel);
      GameBottomSheet.mostrarVictoria(
        context: context,
        pigmentosGanados: 30,
        datoCurioso: fact,
        onContinuar: () {
          Navigator.pop(context);
        },
      );
    } else {
      UserController().restarVida();
      final livesLeft = UserController().currentUser.lives;
      final String mensajeError = _obtenerMensajeError(_controller.datosNivel);

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
          backgroundColor: const Color(0xFF1E2638), 
          appBar: AppBar(
            title: Text('${datos.title} - Nivel ${datos.level}'),
            backgroundColor: const Color(0xFF141824),
            elevation: 0,
            actions: [
              ListenableBuilder(
                listenable: UserController(),
                builder: (context, child) {
                  final user = UserController().currentUser;
                  return Row(
                    children: [
                      // VIDAS
                      const Icon(Icons.favorite_rounded, color: Color(0xFFFF4B4B), size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${user.lives}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 14),
                      // PIGMENTOS
                      const Icon(Icons.diamond_rounded, color: Color(0xFF00C897), size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${user.pigments}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  );
                },
              ),
            ],
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
                      SizedBox(
                        width: esPantallaAncha ? ancho * 0.45 : double.infinity,
                        child: widget.instructionCardBuilder != null
                            ? widget.instructionCardBuilder!(context, _controller)
                            : _buildDefaultInstructionCard(datos),
                      ),
                      const SizedBox(height: 24, width: 24),
                      SizedBox(
                        width: esPantallaAncha ? ancho * 0.45 : double.infinity,
                        child: widget.gameFieldBuilder(context, _controller),
                      ),
                    ],
                  ),
                ),
              ),

              // SI SE ACTIVA LA BANDERA, QUITAMOS EL CONTENEDOR GRIS DE ABAJO COMPLETAMENTE
              if (!widget.ocultarBotonComprobar)
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

  String _obtenerMensajeError(LevelModel model) {
    if (model is ContrastLevelModel) {
      return model.explanation;
    }
    if (model is BlindLevelModel) {
      return model.explanation;
    }
    if (model is MixLevelModel) {
      return "Mezclar pigmentos físicos es sustractivo: busca qué dos reactivos combinados forman el tono objetivo (los primarios son azul, amarillo y rojo).";
    }
    if (model is SearchLevelModel) {
      return "El tono solicitado responde a la psicología del color. Elige el matiz que exprese mejor la emoción del brief.";
    }
    if (model is GradientLevelModel) {
      return "El color correcto debe encajar de forma suave y progresiva en la escala cromática sin romper la gradación visual.";
    }
    if (model is HarmonyLevelModel) {
      return "La respuesta correcta debe formar la relación geométrica solicitada: el complementario (opuesto) o análogo (color vecino en el círculo).";
    }
    if (model is RgbLevelModel) {
      return "El color resultante de tu mezcla difiere del objetivo. Ajusta los canales R, G y B guiándote por el medidor de similitud.";
    }
    if (model is TempLevelModel) {
      return "¡Cuidado! Clasifica los cálidos (rojo, naranja, amarillo) en el frasco izquierdo y los fríos (azul, verde, violeta) en el derecho.";
    }
    if (model is HexLevelModel) {
      return "El código hexadecimal #RRGGBB representa la intensidad del Rojo, Verde y Azul. Compara las muestras con el código dado.";
    }
    if (model is AlbersLevelModel) {
      return model.explanation;
    }
    if (model is AtmosphereLevelModel) {
      return "La paleta correcta debe ser coherente con la temática y las emociones del brief cinematográfico solicitado.";
    }
    if (model is SaturationLevelModel) {
      return "El orden secuencial correcto debe ir de menor a mayor pureza: desde el color más grisáceo hasta el tono más puro y vivo.";
    }
    return "Esa no es la respuesta correcta. ¡Inténtalo de nuevo!";
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