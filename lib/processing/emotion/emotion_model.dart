import 'dart:typed_data';

/// Contrato del modelo de clasificación de expresiones.
abstract interface class EmotionModel {
  Future<void> load();

  /// Orden esperado: happy, neutral, sad, angry, surprise.
  Future<List<double>> predict(Uint8List preparedImage);

  Future<void> dispose();
}
