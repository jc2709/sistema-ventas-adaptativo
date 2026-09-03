import 'dart:typed_data';

/// Preprocesamiento previo a la inferencia.
/// Se ajustará cuando se seleccione el modelo TFLite definitivo.
class ImagePreprocessor {
  const ImagePreprocessor();

  Uint8List prepare(Uint8List faceBytes) => faceBytes;
}
