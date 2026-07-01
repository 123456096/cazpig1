import 'dart:async';
import 'package:flutter/material.dart';

class SplashController extends ChangeNotifier {
  double _progreso = 0.0;
  String _mensaje = "Cargando texturas...";
  Timer? _timer;

  double get progreso => _progreso;
  String get mensaje => _mensaje;

  void iniciarSimulacionDeCarga({required VoidCallback onComplete}) {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_progreso < 1.0) {
        _progreso += 0.01;
        
        if (_progreso > 0.4 && _progreso < 0.7) {
          _mensaje = "Conectando al servidor...";
        } else if (_progreso > 0.7) {
          _mensaje = "Escondiendo los pigmentos secretos...";
        }
        notifyListeners();
      } else {
        timer.cancel();
        onComplete();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
