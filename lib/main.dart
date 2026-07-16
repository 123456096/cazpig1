import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/views/screens/splash_screen.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 5));
  } catch (e) {
    debugPrint("Firebase no pudo inicializar en el arranque nativo: $e");
  }

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