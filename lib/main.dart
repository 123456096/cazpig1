import 'package:flutter/material.dart';
import 'src/views/screens/splash_screen.dart';

void main() {
  runApp(const CazadoresApp());
}

class CazadoresApp extends StatelessWidget {
  const CazadoresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cazadores de Pigmentos',
      home: SplashScreen(),
    );
  }
}