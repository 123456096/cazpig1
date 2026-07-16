import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class LoggingService {
  // Instancias de los servicios de Firebase
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Inicialización global del servicio de monitoreo en el arranque de la app
  static Future<void> inicializar() async {
    // SOPORTE WEB: Si la app corre en Web, Crashlytics no se inicializa para evitar errores
    if (kIsWeb) {
      print('ℹ️ [MONITOREO] Entorno Web detectado. Firebase Crashlytics omitido.');
      return;
    }

    if (kDebugMode) {
      await _crashlytics.setCrashlyticsCollectionEnabled(false);
      print('ℹ️ [MONITOREO] Crashlytics desactivado en modo Desarrollo (Móvil).');
    } else {
      await _crashlytics.setCrashlyticsCollectionEnabled(true);
      // Capturar automáticamente excepciones de renderizado o fallos fatales no controlados en Flutter móvil
      FlutterError.onError = _crashlytics.recordFlutterFatalError;
    }
  }

  /// Registra un evento de seguridad estructurado (OWASP A09)
  static Future<void> logSecurityEvent({
    required String nombreEvento,
    required String descripcion,
    Map<String, Object>? detalles,
  }) async {
    // Firebase Analytics sí funciona en Web y Móvil sin problemas
    await _analytics.logEvent(
      name: 'security_$nombreEvento',
      parameters: detalles ?? {},
    );

    // Solo escribimos en las trazas de Crashlytics si no estamos en entorno Web
    if (!kIsWeb) {
      await _crashlytics.log('ALERTA SEGURO [${nombreEvento.toUpperCase()}]: $descripcion');
    }
    
    if (kDebugMode) {
      print('⚠️ [LOG DE SEGURIDAD] $nombreEvento: $descripcion');
    }
  }

  /// Registra excepciones o fallos técnicos controlados dentro de bloques try-catch
  static Future<void> logException(
    dynamic exception, 
    StackTrace stack, {
    String reason = '',
  }) async {
    // Si es web, solo imprimimos en la consola del navegador para análisis local sin tronar
    if (kIsWeb) {
      print('❌ [EXCEPCIÓN WEB] Razón: $reason | Error: $exception\n$stack');
      return;
    }

    // Si es móvil en producción, se envía el reporte completo a la consola de Firebase
    await _crashlytics.recordError(exception, stack, reason: reason);
    
    if (kDebugMode) {
      print('❌ [EXCEPCIÓN MÓVIL CAPTURADA] Razón: $reason | Error: $exception');
    }
  }
}