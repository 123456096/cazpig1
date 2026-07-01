import 'package:flutter/material.dart';

class GameButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color shadowColor;
  final double height;
  final double width;
  final double borderRadius;
  final bool enabled;

  const GameButton({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor = Colors.orange,
    this.shadowColor = const Color(0xFFE65100),
    this.height = 50,
    this.width = double.infinity,
    this.borderRadius = 16,
    this.enabled = true,
  });

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    const double depth = 6.0;
    final Color currentBgColor = widget.enabled ? widget.backgroundColor : Colors.grey.shade400;
    final Color currentShadowColor = widget.enabled ? widget.shadowColor : Colors.grey.shade600;

    return GestureDetector(
      onTapDown: widget.enabled && widget.onTap != null
          ? (_) => setState(() => _isPressed = true)
          : null,
      onTapUp: widget.enabled && widget.onTap != null
          ? (_) {
              setState(() => _isPressed = false);
              widget.onTap!();
            }
          : null,
      onTapCancel: widget.enabled && widget.onTap != null
          ? () => setState(() => _isPressed = false)
          : null,
      child: SizedBox(
        width: widget.width,
        height: widget.height + depth,
        child: Stack(
          children: [
            // Sombra inferior (Base 3D)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: widget.height,
              child: Container(
                decoration: BoxDecoration(
                  color: currentShadowColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
              ),
            ),
            // Frente del botón (Mecánico)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 60),
              top: _isPressed ? depth : 0,
              left: 0,
              right: 0,
              height: widget.height,
              child: Container(
                decoration: BoxDecoration(
                  color: currentBgColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
