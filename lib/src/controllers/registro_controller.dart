import 'package:flutter/material.dart';
import '../models/user_model.dart';

class RegistroController extends ChangeNotifier {
  final emailController = TextEditingController();
  final edadController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    edadController.dispose();
    super.dispose();
  }

  String? validarEmail(String? value) {
    if (value == null || value.isEmpty) return 'Ingresa tu correo';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Correo inválido';
    return null;
  }

  String? validarEdad(String? value) {
    if (value == null || value.isEmpty) return 'Ingresa tu edad';
    final edad = int.tryParse(value);
    if (edad == null || edad <= 0 || edad > 120) return 'Edad inválida';
    return null;
  }

  UserModel registrarUsuario() {
    return UserModel.initial(
      email: emailController.text,
      age: edadController.text,
    );
  }
}
