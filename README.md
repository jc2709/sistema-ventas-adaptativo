# Sistema de Ventas Adaptativo

Proyecto base en Flutter para el Taller 1 de Desarrollo de una Aplicación Adaptativa.

## Pipeline adaptativo

`CONTEXTO -> PROCESAMIENTO -> DECISIÓN -> ADAPTACIÓN`

- **Contexto:** captura de imagen/rostro mediante cámara.
- **Procesamiento:** clasificación de expresión facial.
- **Decisión:** reglas que determinan la respuesta del sistema.
- **Adaptación:** cambios visibles en ofertas, recomendaciones o interfaz.

## Responsabilidades iniciales

- **Steven:** `lib/context/` y principalmente `lib/presentation/`.
- **Juan:** `lib/processing/emotion/` y `test/emotion/`.
- **Elvis:** `lib/decision/`, `lib/data/` y `lib/auth/`.
- **Equipo:** `lib/services/`, integración y pruebas finales.

## Estructura

```text
lib/
├── context/camera/
├── processing/emotion/
├── decision/adaptation/
├── data/database/
├── data/repositories/
├── auth/
├── domain/models/
├── presentation/screens/
├── presentation/widgets/
├── services/
└── main.dart
```

## Preparación local

Si todavía no existen las carpetas nativas de Flutter en tu copia local, ejecuta una sola vez:

```bash
flutter create --project-name sistema_ventas_adaptativo --platforms=android .
flutter pub get
flutter run
```

Pruebas:

```bash
flutter test
```

APK:

```bash
flutter build apk
```

Normalmente se genera en `build/app/outputs/flutter-apk/app-release.apk`.

## Modelo de emociones

El archivo `.tflite` todavía no está incluido. Debe añadirse posteriormente en `assets/models/` cuando se seleccione un modelo con licencia apropiada y se documenten sus dimensiones de entrada, normalización y orden de etiquetas.

## Ramas de trabajo

- `feature/camera`
- `feature/emotion-model`
- `feature/adaptation-rules`

Evitar trabajar directamente sobre `main` para nuevas funcionalidades.
