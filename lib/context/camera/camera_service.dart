import 'dart:typed_data';

/// Captura del CONTEXTO.
abstract interface class CameraService {
  Future<Uint8List?> captureFrame();
}
