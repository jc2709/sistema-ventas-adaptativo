import 'dart:typed_data';

/// Preprocesamiento ligero previo a la inferencia.
///
/// La conversión a tamaño/canales/normalización se realiza dentro del
/// adaptador TFLite porque depende de la forma real del tensor de entrada.
class ImagePreprocessor {
  const ImagePreprocessor();

  Uint8List prepare(Uint8List faceBytes) {
    if (faceBytes.isEmpty) {
      throw ArgumentError('La imagen no puede estar vacía.');
    }
    return faceBytes;
  }
}
