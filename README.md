# Pigmento

Aplicación Flutter: **Cazadores de Pigmentos**

Este proyecto es una app Flutter creada con `flutter create` y usa una pantalla de splash para iniciar la aplicación.

## Dependencias principales

- `cupertino_icons` 1.0.8
- `shared_preferences` 2.2.0
- `lottie` 3.1.2

## Requisitos

- Flutter instalado y accesible en la terminal
- SDK de Dart compatible con Flutter 3.11+
- Dispositivo o emulador Android/iOS, o plataforma de escritorio soportada

## Instalación de dependencias

Desde el directorio raíz del proyecto:

```bash
cd /home/angel-yael/cazpig
flutter pub get
```

Eso descarga e instala todas las dependencias definidas en `pubspec.yaml`.

## Cómo ejecutar la app

Para correr la app en el dispositivo/emulador conectado:

```bash
flutter run
```

Opciones útiles:

- Ejecutar en Android:
  ```bash
  flutter run -d android
  ```
- Ejecutar en Linux:
  ```bash
  flutter run -d linux
  ```
- Ejecutar en iOS:
  ```bash
  flutter run -d ios
  ```

## Construir APK / aplicación

Para generar un APK de Android:

```bash
flutter build apk
```

Para generar una app de escritorio Linux:

```bash
flutter build linux
```

## Activos incluidos

El proyecto usa estos activos:

- `assets/imagenes/icon1.png`
- `assets/imagenes/icon2.png`
- `assets/spinners/spinner.json`

## Notas

- Si necesitas verificar la configuración de Flutter, usa:
  ```bash
  flutter doctor -v
  ```
- Si quieres ver si hay versiones nuevas de paquetes, usa:
  ```bash
  flutter pub outdated
  ```

¡Listo! Con estos pasos podrás instalar dependencias y ejecutar el proyecto en tu equipo.
