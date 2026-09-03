import 'dart:typed_data';

/// Extrae el rostro que luego será procesado por el módulo de emociones.
abstract interface class FaceDetector {
  Future<Uint8List?> extractFace(Uint8List imageBytes);
}
