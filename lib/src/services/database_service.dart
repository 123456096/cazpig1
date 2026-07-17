import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../services/logging_service.dart'; // Integración de Monitoreo A09

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Convierte TU UserModel a un Map compatible con Firestore
  Map<String, dynamic> _userToMap(UserModel user) {
    return {
      'email': user.email,
      'age': user.age,
      'name': user.name,
      'avatarUrl': user.avatarUrl,
      'xp': user.xp,
      'level': user.level,
      'currentLevelReached': user.currentLevelReached,
      'lives': user.lives,
      'streak': user.streak,
      'pigments': user.pigments,
      'isOffline': user.isOffline,
      'title': user.title,
      'badges': user.badges,
      'lastLogin': FieldValue.serverTimestamp(), // Integridad temporal: Firma nativa del servidor
    };
  }

  // Convierte lo que viene de Firestore de vuelta a TU UserModel
  UserModel _mapToUser(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      age: map['age'] ?? '',
      name: map['name'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      xp: map['xp'] ?? 0,
      level: map['level'] ?? 1,
      currentLevelReached: map['currentLevelReached'] ?? 1,
      lives: map['lives'] ?? 5,
      streak: map['streak'] ?? 0,
      pigments: map['pigments'] ?? 0,
      isOffline: map['isOffline'] ?? false,
      title: map['title'] ?? '',
      badges: List<String>.from(map['badges'] ?? []),
    );
  }

  // 1. Guardar o actualizar el perfil principal del usuario (users/{uid})
  Future<void> saveUserProfile(String uid, UserModel user) async {
    try {
      await _db.collection('users').doc(uid).set(_userToMap(user), SetOptions(merge: true));
      print("¡Perfil de usuario sincronizado en Firestore!");
    } catch (e, stack) {
      await LoggingService.logException(e, stack, reason: 'Fallo al sincronizar perfil de usuario uid: $uid');
    }
  }

  // 2. Obtener los datos del usuario desde Firestore
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return _mapToUser(doc.data() as Map<String, dynamic>);
      }
    } catch (e, stack) {
      await LoggingService.logException(e, stack, reason: 'Error al obtener perfil de usuario uid: $uid');
    }
    return null;
  }

  // 3. Guardar el resultado de una partida en la subcolección (users/{uid}/gameResults/{nivelId})
  Future<void> saveGameResult({
    required String uid,
    required int nivel,
    required bool completado,
    required int aciertos,
    required int errores,
    required int pigmentosGanados,
  }) async {
    try {
      await _db
          .collection('users')
          .doc(uid)
          .collection('gameResults')
          .doc('nivel_$nivel') 
          .set({
        'nivel': nivel,
        'completado': completado,
        'fecha': FieldValue.serverTimestamp(), // Firma de tiempo del servidor contra alteración horaria
        'aciertos': aciertos,
        'errores': errores,
        'pigmentosGanados': pigmentosGanados,
      });
      print("¡Resultado del nivel $nivel registrado con éxito!");
    } catch (e, stack) {
      await LoggingService.logException(e, stack, reason: 'Fallo al guardar resultado del juego para uid: $uid');
    }
  }

  // 4. CORREGIDO POR INTEGRIDAD (A08): Uso exclusivo de incrementos atómicos para modificar vidas
  Future<void> modifyUserLivesAtomic(String uid, int deltaVidas) async {
    try {
      await _db.collection('users').doc(uid).update({
        'lives': FieldValue.increment(deltaVidas),
      });
      print("Vidas modificadas atómicamente en ($deltaVidas) con éxito.");
    } catch (e, stack) {
      await LoggingService.logException(e, stack, reason: 'Error al actualizar vidas de forma atómica para uid: $uid');
    }
  }

  // 5. Sumar o restar pigmentos usando un incremento atómico en el servidor
  Future<void> addPigments(String uid, int cantidad) async {
    try {
      await _db.collection('users').doc(uid).update({
        'pigments': FieldValue.increment(cantidad),
      });
      print("Se modificaron los pigmentos en ($cantidad) con éxito.");
    } catch (e, stack) {
      await LoggingService.logException(e, stack, reason: 'Error al actualizar pigmentos para uid: $uid');
    }
  }

  // 6. CORREGIDO POR INTEGRIDAD (A08): El progreso de nivel se incrementa de forma matemática regulada en el servidor
  Future<void> markLevelCompleted(String uid, int nivel) async {
    try {
      await _db.collection('users').doc(uid).update({
        'completedLevels': FieldValue.arrayUnion(['nivel_$nivel']),
        'currentLevelReached': FieldValue.increment(1), 
        'level': FieldValue.increment(1), 
      });
      print("¡Nivel $nivel actualizado de forma atómica!");
    } catch (e, stack) {
      await LoggingService.logException(e, stack, reason: 'Error al marcar nivel completado para uid: $uid');
    }
  }
}