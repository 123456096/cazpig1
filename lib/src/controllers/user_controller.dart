import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import '../services/logging_service.dart'; // Monitoreo A09

class UserController extends ChangeNotifier {
  static final UserController _instance = UserController._internal();
  factory UserController() => _instance;
  UserController._internal();

  UserModel? _currentUser;
  final DatabaseService _dbService = DatabaseService();

  UserModel get currentUser => _currentUser ?? UserModel.initial(email: "invitado@correo.com", age: "0");

  /// OBTENER ID SEGURO PARA FIRESTORE
  String? get _docId {
    if (_currentUser == null || currentUser.email == "invitado@correo.com" || currentUser.isOffline) return null;
    return currentUser.email.replaceAll('.', '_');
  }

  /// Sincronización general (solo para inicio de sesión o cambios estructurales completos)
  Future<void> _sincronizarConFirebase() async {
    final uid = _docId;
    if (uid == null) return;
    try {
      await _dbService.saveUserProfile(uid, currentUser);
      print("¡Progreso completo de ${currentUser.email} sincronizado en Firebase!");
    } catch (e, stack) {
      await LoggingService.logException(e, stack, reason: 'Error al sincronizar perfil completo en UserController');
    }
  }

  /// Inicializa el usuario (después del login)
  void inicializarUsuario({required String email, required String age, required bool isOffline}) {
    _currentUser = UserModel.initial(email: email, age: age, isOffline: isOffline);
    _verificarRachaDiaria();
    guardarProgresoLocal();
    _sincronizarConFirebase();
    notifyListeners();
  }

  /// Inicializa el usuario tomando todos los datos desde un perfil existente (Firestore)
  Future<void> inicializarDesdePerfil(UserModel profile) async {
    _currentUser = profile;
    _verificarRachaDiaria();
    await guardarProgresoLocal();
    notifyListeners();
  }

  /// Carga los datos guardados en el almacenamiento local (SharedPreferences)
  Future<void> cargarProgresoLocal() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("cazpig_email")) {
      final email = prefs.getString("cazpig_email") ?? "";
      final age = prefs.getString("cazpig_age") ?? "";
      final name = prefs.getString("capig_name") ?? "Ele Cruz";
      final avatarUrl = prefs.getString("cazpig_avatar") ?? "assets/avatar/avatar1.jpeg";
      final xp = prefs.getInt("cazpig_xp") ?? 0;
      final level = prefs.getInt("cazpig_level") ?? 1;
      final currentLevelReached = prefs.getInt("cazpig_current_level") ?? 1;
      final lives = prefs.getInt("cazpig_lives") ?? 5;
      final streak = prefs.getInt("cazpig_streak") ?? 0;
      final pigments = prefs.getInt("cazpig_pigments") ?? 0;
      final isOffline = prefs.getBool("cazpig_is_offline") ?? false;
      final title = prefs.getString("cazpig_title") ?? "Cazador Novato";
      final badges = prefs.getStringList("cazpig_badges") ?? [];

      _currentUser = UserModel(
        email: email,
        age: age,
        name:name,
        avatarUrl:avatarUrl,
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
    await prefs.setString("cazpig_name", currentUser.name);
    await prefs.setString("cazpig_avatar",currentUser.avatarUrl);
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

  /// CORREGIDO POR INTEGRIDAD (A08): Usa llamadas atómicas individuales en vez de pisar todo el JSON
  void completarNivel(int nivel) async {
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

    // 1. Guardado en caché local
    await guardarProgresoLocal();
    
    // 2. BLINDAJE A08: Envío de transacciones matemáticas controladas al servidor
    final uid = _docId;
    if (uid != null) {
      // Incrementamos el nivel alcanzado y los pigmentos de forma segura en Firebase
      await _dbService.markLevelCompleted(uid, nivel);
      await _dbService.addPigments(uid, 30);
      
      // Guardamos la bitácora específica de la partida terminada en la subcolección
      await _dbService.saveGameResult(
        uid: uid,
        nivel: nivel,
        completado: true,
        aciertos: 5, 
        errores: 0,
        pigmentosGanados: 30,
      );
    }

    verificarYDesbloquearLogros();
    notifyListeners();
  }

  /// CORREGIDO POR INTEGRIDAD (A08): Resta vidas usando decrementos atómicos del servidor
  void restarVida() async {
    if (currentUser.lives > 0) {
      int nuevasVidas = currentUser.lives - 1;
      _currentUser = currentUser.copyWith(lives: nuevasVidas);

      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString("cazpig_last_life_loss") == null) {
        await prefs.setString("cazpig_last_life_loss", DateTime.now().toIso8601String());
      }
      
      await guardarProgresoLocal();

      // BLINDAJE A08: Enviamos un delta negativo (-1) al servidor en vez de forzar un valor absoluto
      final uid = _docId;
      if (uid != null) {
        await _dbService.modifyUserLivesAtomic(uid, -1);
      }
      
      notifyListeners();
    }
  }

  /// CORREGIDO POR INTEGRIDAD (A08): Recupera vidas al máximo de forma atómica
  void recuperarVidas() async {
    int vidasFaltantes = 5 - currentUser.lives;
    _currentUser = currentUser.copyWith(lives: 5);
    await guardarProgresoLocal();

    final uid = _docId;
    if (uid != null && vidasFaltantes > 0) {
      await _dbService.modifyUserLivesAtomic(uid, vidasFaltantes);
    }
    notifyListeners();
  }

  /// CORREGIDO POR INTEGRIDAD (A08): Compra de vidas gestionada de manera atómica doble (Vidas y Monedas)
  bool comprarVidasConPigmentos() {
    if (currentUser.pigments >= 150) {
      int vidasFaltantes = 5 - currentUser.lives;
      
      _currentUser = currentUser.copyWith(
        lives: 5,
        pigments: currentUser.pigments - 150,
      );
      
      guardarProgresoLocal();

      // BLINDAJE A08: Modificación síncrona en base de datos sin peligro de inyección por proxy de red
      final uid = _docId;
      if (uid != null) {
        _dbService.addPigments(uid, -150);
        if (vidasFaltantes > 0) {
          _dbService.modifyUserLivesAtomic(uid, vidasFaltantes);
        }
      }
      
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Calcula la regeneración pasiva de vidas por tiempo transcurrido (5 min por vida)
  Future<void> _regenerarVidasPorTiempo() async {
    if (currentUser.lives >= 5) return;
    final prefs = await SharedPreferences.getInstance();
    String? timeStr = prefs.getString("cazpig_last_life_loss");
    if (timeStr == null) {
      // Robustez: si le faltan vidas pero no hay marca de tiempo, la creamos ahora
      await prefs.setString("cazpig_last_life_loss", DateTime.now().toIso8601String());
      return;
    }
 
    final lastLoss = DateTime.parse(timeStr);
    final diff = DateTime.now().difference(lastLoss).inMinutes;
 
    int vidasARecuperar = (diff / 5).floor();
    if (vidasARecuperar > 0) {
      int nuevasVidas = (currentUser.lives + vidasARecuperar).clamp(0, 5);
      int deltaVidasRecuperadas = nuevasVidas - currentUser.lives;
      
      _currentUser = currentUser.copyWith(lives: nuevasVidas);
      
      if (nuevasVidas < 5) {
        final remanenteMinutos = diff % 5;
        final nuevaMarca = DateTime.now().subtract(Duration(minutes: remanenteMinutos));
        await prefs.setString("cazpig_last_life_loss", nuevaMarca.toIso8601String());
      } else {
        await prefs.remove("cazpig_last_life_loss");
      }
      
      await guardarProgresoLocal();

      final uid = _docId;
      if (uid != null && deltaVidasRecuperadas > 0) {
        await _dbService.modifyUserLivesAtomic(uid, deltaVidasRecuperadas);
      }
    }
  }

  /// Método público para forzar la verificación y regeneración de vidas
  Future<void> verificarYRegenerarVidas() async {
    await _regenerarVidasPorTiempo();
    notifyListeners();
  }

  /// Verifica y calcula las rachas consecutivas de juego diario.
  Future<void> _verificarRachaDiaria() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLoginStr = prefs.getString("cazpig_last_login");
    final now = DateTime.now();
    int rachaAnterior = currentUser.streak;

    if (lastLoginStr != null) {
      final lastLogin = DateTime.parse(lastLoginStr);
      final differenceInHours = now.difference(lastLogin).inHours;

      if (differenceInHours > 48) {
        _currentUser = currentUser.copyWith(streak: 0);
      } else if (differenceInHours >= 24) {
        _currentUser = currentUser.copyWith(streak: currentUser.streak + 1);
      }
    }

    await prefs.setString("cazpig_last_login", now.toIso8601String());
    await guardarProgresoLocal();
    
    // Si la racha cambió, actualizamos el perfil completo en Firebase
    if (currentUser.streak != rachaAnterior) {
      _sincronizarConFirebase();
    }
    verificarYDesbloquearLogros();
  }

  Future<void> actualizarPerfil({required String nuevoNombre,required String nuevoAvatar})async{
    if (_currentUser == null) return;

    _currentUser = currentUser.copyWith(
     name:nuevoNombre,
     avatarUrl:nuevoAvatar,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("cazpig_name", nuevoNombre);
    await prefs.setString("cazpig_avatar", nuevoAvatar);
    notifyListeners();
  }

  /// VALIDA E INSERTA NUEVOS LOGROS
  void verificarYDesbloquearLogros() async {
    final list = List<String>.from(currentUser.badges);
    bool cambio = false;

    void desbloquear(String insignia) {
      if (!list.contains(insignia)) {
        list.add(insignia);
        cambio = true;
      }
    }

    // 1. Primer Trazo: Completar el nivel 1
    if (currentUser.currentLevelReached > 1) {
      desbloquear("Primer Trazo");
    }

    // 2. Racha Color: Racha de 3 o más
    if (currentUser.streak >= 3) {
      desbloquear("Racha Color");
    }

    // 3. Estudiante Estrella: Nivel >= 3
    if (currentUser.level >= 3) {
      desbloquear("Estudiante Estrella");
    }

    // 4. Sin Mancharse: Llegar al nivel 5
    if (currentUser.currentLevelReached >= 5) {
      desbloquear("Sin Mancharse");
    }

    // 5. Ojo Entrenado: Llegar al nivel 10
    if (currentUser.currentLevelReached >= 10) {
      desbloquear("Ojo Entrenado");
    }

    // 6. Ojo Mágico: Llegar al nivel 15
    if (currentUser.currentLevelReached >= 15) {
      desbloquear("Ojo Mágico");
    }

    // 7. Cazador Definitivo: Llegar al nivel 25
    if (currentUser.currentLevelReached >= 25) {
      desbloquear("Cazador Definitivo");
    }

    // 8. Velocidad luz: Nivel >= 8
    if (currentUser.level >= 8) {
      desbloquear("Velocidad luz");
    }

    // 9. En la zona: Racha >= 5
    if (currentUser.streak >= 5) {
      desbloquear("En la zona");
    }

    // 10. Línea Recta: Racha >= 7 (nota: el perfil busca "Linea Recta" sin acento)
    if (currentUser.streak >= 7) {
      desbloquear("Linea Recta");
    }

    if (cambio) {
      _currentUser = currentUser.copyWith(badges: list);
      await guardarProgresoLocal();

      final uid = _docId;
      if (uid != null) {
        await _dbService.saveUserProfile(uid, currentUser);
      }
      notifyListeners();
    }
  }

  /// RESTABLECE TODO EL AVANCE
  Future<void> reiniciarTodoElProgreso() async {
    final prefs = await SharedPreferences.getInstance();
    
    final email = currentUser.email;
    final age = currentUser.age;
    final isOffline = currentUser.isOffline;

    _currentUser = UserModel.initial(email: email, age: age, isOffline: isOffline);

    await prefs.remove("cazpig_xp");
    await prefs.remove("cazpig_level");
    await prefs.remove("cazpig_current_level");
    await prefs.remove("cazpig_lives");
    await prefs.remove("cazpig_streak");
    await prefs.remove("cazpig_pigments");
    await prefs.remove("cazpig_title");
    await prefs.remove("cazpig_badges");
    await prefs.remove("cazpig_last_life_loss");
    await prefs.remove("cazpig_last_login");

    await guardarProgresoLocal();

    final uid = _docId;
    if (uid != null) {
      await _dbService.saveUserProfile(uid, currentUser);
    }

    notifyListeners();
  }
}
