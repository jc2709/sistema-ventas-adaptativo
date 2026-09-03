# Modelo de emociones

El módulo espera el archivo:

`assets/models/emotion_model.tflite`

## Modelo de referencia

Se eligió como referencia el modelo público del repositorio:

`Shubham-Zone/Emotion-detection-using-tflite`

Archivo original:

`assets/model.tflite`

Licencia del repositorio: MIT.

Al incorporarlo a este proyecto debe renombrarse a:

`emotion_model.tflite`

## Etiquetas

El orden de salida documentado por el modelo es:

0. Happy
1. Sad
2. Surprised
3. Fearful
4. Angry
5. Disgusted
6. Neutral

El código del proyecto usa ese mismo orden:

`happy, sad, surprise, fear, angry, disgust, neutral`

## Preprocesamiento

`TfliteEmotionModel` inspecciona el tensor de entrada en tiempo de ejecución y:

- acepta tensores NHWC `[1, alto, ancho, canales]`;
- soporta 1 canal (grayscale) o 3 canales (RGB);
- redimensiona automáticamente la imagen al tamaño del tensor;
- normaliza cada píxel con `(pixel - 127.5) / 127.5`;
- valida que la salida tenga exactamente 7 valores.

## Probar solo este módulo

Después de colocar el modelo:

```bash
flutter pub get
flutter test test/emotion
flutter run -t lib/emotion_debug_main.dart
```

La pantalla de depuración permite tomar una foto con la cámara frontal o seleccionar una imagen de la galería y muestra la emoción detectada y su confianza.
