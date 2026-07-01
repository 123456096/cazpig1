import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserController extends ChangeNotifier {
  static final UserController _instance = UserController._internal();
  factory UserController() => _instance;
  UserController._internal();

  UserModel? _currentUser;

  UserModel get currentUser => _currentUser ?? UserModel.initial(email: "invitado@correo.com", age: "0");

  /// Inicializa el usuario (después del login)
  void inicializarUsuario({required String email, required String age, required bool isOffline}) {
    _currentUser = UserModel.initial(email: email, age: age, isOffline: isOffline);
    _verificarRachaDiaria();
    guardarProgresoLocal();
    notifyListeners();
  }

  /// Carga los datos guardados en el almacenamiento local
  Future<void> cargarProgresoLocal() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("cazpig_email")) {
      final email = prefs.getString("cazpig_email") ?? "";
      final age = prefs.getString("cazpig_age") ?? "";
      final xp = prefs.getInt("cazpig_xp") ?? 1250;
      final level = prefs.getInt("cazpig_level") ?? 5;
      final currentLevelReached = prefs.getInt("cazpig_current_level") ?? 1;
      final lives = prefs.getInt("cazpig_lives") ?? 5;
      final streak = prefs.getInt("cazpig_streak") ?? 5;
      final pigments = prefs.getInt("cazpig_pigments") ?? 591;
      final isOffline = prefs.getBool("cazpig_is_offline") ?? false;
      final title = prefs.getString("cazpig_title") ?? "Cazador Experto";
      final badges = prefs.getStringList("cazpig_badges") ?? ["Primer Trazo", "Racha Color", "Ojo Mágico"];

      _currentUser = UserModel(
        email: email,
        age: age,
        xp: xp,
        level: level,
        currentLevelReached: currentLevelReached,
        lives: lives,
        streak: streak,
        pigments: pigments,
        isOffline: isOffline,
        title: title,
        badges: badges,
      );

      // Checar vidas por tiempo al cargar
      _regenerarVidasPorTiempo();
      _verificarRachaDiaria();
      notifyListeners();
    }
  }

  /// Guarda los datos del usuario en SharedPreferences
  Future<void> guardarProgresoLocal() async {
    if (_currentUser == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("cazpig_email", currentUser.email);
    await prefs.setString("cazpig_age", currentUser.age);
    await prefs.setInt("cazpig_xp", currentUser.xp);
    await prefs.setInt("cazpig_level", currentUser.level);
    await prefs.setInt("cazpig_current_level", currentUser.currentLevelReached);
    await prefs.setInt("cazpig_lives", currentUser.lives);
    await prefs.setInt("cazpig_streak", currentUser.streak);
    await prefs.setInt("cazpig_pigments", currentUser.pigments);
    await prefs.setBool("cazpig_is_offline", currentUser.isOffline);
    await prefs.setString("cazpig_title", currentUser.title);
    await prefs.setStringList("cazpig_badges", currentUser.badges);
  }

  /// Registra el fin de un nivel exitoso (+100 XP, +30 Pigmentos)
  void completarNivel(int nivel) {
    _currentUser ??= UserModel.initial(email: "invitado@correo.com", age: "0");

    int nuevaXp = currentUser.xp + 100;
    int nuevosPigmentos = currentUser.pigments + 30;
    int nuevoNivel = (nuevaXp / 500).floor() + 1;
    
    String nuevoTitulo = "Cazador Novato";
    if (nuevoNivel >= 3 && nuevoNivel < 5) nuevoTitulo = "Cazador Intermedio";
    if (nuevoNivel >= 5 && nuevoNivel < 8) nuevoTitulo = "Cazador Experto";
    if (nuevoNivel >= 8) nuevoTitulo = "Maestro de Pigmentos";

    int nuevoNivelAlcanzado = currentUser.currentLevelReached;
    if (nivel == currentUser.currentLevelReached) {
      nuevoNivelAlcanzado = nivel + 1;
    }

    _currentUser = currentUser.copyWith(
      xp: nuevaXp,
      pigments: nuevosPigmentos,
      level: nuevoNivel,
      currentLevelReached: nuevoNivelAlcanzado,
      title: nuevoTitulo,
    );

    guardarProgresoLocal();
    notifyListeners();
  }

  /// Restar 1 vida por respuesta incorrecta
  void restarVida() async {
    if (currentUser.lives > 0) {
      int nuevasVidas = currentUser.lives - 1;
      _currentUser = currentUser.copyWith(lives: nuevasVidas);

      final prefs = await SharedPreferences.getInstance();
      if (nuevasVidas == 4) {
        // Iniciar marca de tiempo para regenerar vidas
        await prefs.setString("cazpig_last_life_loss", DateTime.now().toIso8601String());
      }
      guardarProgresoLocal();
      notifyListeners();
    }
  }

  /// Restaura vidas al máximo
  void recuperarVidas() {
    _currentUser = currentUser.copyWith(lives: 5);
    guardarProgresoLocal();
    notifyListeners();
  }

  /// Compra vidas con pigmentos de la economía del juego
  bool comprarVidasConPigmentos() {
    if (currentUser.pigments >= 150) {
      _currentUser = currentUser.copyWith(
        lives: 5,
        pigments: currentUser.pigments - 150,
      );
      guardarProgresoLocal();
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Calcula vidas a regenerar basándose en el tiempo transcurrido (5 mins por vida)
  Future<void> _regenerarVidasPorTiempo() async {
    if (currentUser.lives >= 5) return;
    final prefs = await SharedPreferences.getInstance();
    final timeStr = prefs.getString("cazpig_last_life_loss");
    if (timeStr == null) return;

    final lastLoss = DateTime.parse(timeStr);
    final diff = DateTime.now().difference(lastLoss).inMinutes;

    // 5 minutos por vida
    int vidasARecuperar = (diff / 5).floor();
    if (vidasARecuperar > 0) {
      int nuevasVidas = (currentUser.lives + vidasARecuperar).clamp(0, 5);
      _currentUser = currentUser.copyWith(lives: nuevasVidas);
      
      if (nuevasVidas < 5) {
        // Actualizar marca con el remanente
        final remanenteMinutos = diff % 5;
        final nuevaMarca = DateTime.now().subtract(Duration(minutes: remanenteMinutos));
        await prefs.setString("cazpig_last_life_loss", nuevaMarca.toIso8601String());
      } else {
        await prefs.remove("cazpig_last_life_loss");
      }
      guardarProgresoLocal();
    }
  }

  /// Verifica y calcula las rachas consecutivas de juego diario
  Future<void> _verificarRachaDiaria() async {
    final prefs = await SharedPreferences.getInstance();
    final lastPlayStr = prefs.getString("cazpig_last_play_date");
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);

    if (lastPlayStr != null) {
      final lastPlay = DateTime.parse(lastPlayStr);
      final lastPlayDateOnly = DateTime(lastPlay.year, lastPlay.month, lastPlay.day);
      final differenceInDays = todayDateOnly.difference(lastPlayDateOnly).inDays;

      if (differenceInDays == 1) {
        int nuevaRacha = currentUser.streak + 1;
        _currentUser = currentUser.copyWith(streak: nuevaRacha);
      } else if (differenceInDays > 1) {
        _currentUser = currentUser.copyWith(streak: 1);
      }
    } else {
      _currentUser = currentUser.copyWith(streak: 5); // 5 por defecto inicial
    }
    await prefs.setString("cazpig_last_play_date", todayDateOnly.toIso8601String());
    guardarProgresoLocal();
  }
}
