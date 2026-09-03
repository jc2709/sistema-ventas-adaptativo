import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import 'emotion_model.dart';

/// Implementación de [EmotionModel] usando TensorFlow Lite.
///
/// Soporta tensores de entrada NHWC con 1 o 3 canales y normaliza los
/// píxeles al rango [-1, 1], equivalente a mean=127.5 / std=127.5.
class TfliteEmotionModel implements EmotionModel {
  TfliteEmotionModel({
    this.assetPath = 'assets/models/emotion_model.tflite',
    this.numThreads = 2,
  });

  final String assetPath;
  final int numThreads;

  Interpreter? _interpreter;

  bool get isLoaded => _interpreter != null;

  @override
  Future<void> load() async {
    if (_interpreter != null) return;

    final options = InterpreterOptions()..threads = numThreads;
    _interpreter = await Interpreter.fromAsset(assetPath, options: options);

    final input = _interpreter!.getInputTensor(0);
    final output = _interpreter!.getOutputTensor(0);

    if (input.shape.length != 4 || input.shape.first != 1) {
      await dispose();
      throw StateError(
        'Tensor de entrada no soportado: ${input.shape}. Se esperaba [1, alto, ancho, canales].',
      );
    }

    final channels = input.shape[3];
    if (channels != 1 && channels != 3) {
      await dispose();
      throw StateError(
        'Cantidad de canales no soportada: $channels. Solo se admite grayscale o RGB.',
      );
    }

    if (output.shape.isEmpty || output.shape.last != 7) {
      await dispose();
      throw StateError(
        'Tensor de salida incompatible: ${output.shape}. Se esperaban 7 emociones.',
      );
    }
  }

  @override
  Future<List<double>> predict(Uint8List preparedImage) async {
    final interpreter = _interpreter;
    if (interpreter == null) {
      throw StateError('El modelo debe cargarse con load() antes de predecir.');
    }

    final decoded = img.decodeImage(preparedImage);
    if (decoded == null) {
      throw ArgumentError('No se pudo decodificar la imagen del rostro.');
    }

    final shape = interpreter.getInputTensor(0).shape;
    final height = shape[1];
    final width = shape[2];
    final channels = shape[3];

    final resized = img.copyResize(decoded, width: width, height: height);
    final input = _buildInput(resized, height, width, channels);
    final output = List.generate(1, (_) => List<double>.filled(7, 0));

    interpreter.run(input, output);

    final scores = output.first;
    final total = scores.fold<double>(0, (sum, value) => sum + value);

    // Algunos modelos ya entregan probabilidades. Para modelos que devuelven
    // logits aplicamos softmax para mantener el contrato [0, 1].
    final alreadyProbabilities = scores.every((value) => value >= 0 && value <= 1) &&
        (total - 1).abs() < 0.05;

    return alreadyProbabilities ? scores : _softmax(scores);
  }

  List<List<List<List<double>>>> _buildInput(
    img.Image image,
    int height,
    int width,
    int channels,
  ) {
    return [
      List.generate(height, (y) {
        return List.generate(width, (x) {
          final pixel = image.getPixel(x, y);
          final r = pixel.r.toDouble();
          final g = pixel.g.toDouble();
          final b = pixel.b.toDouble();

          if (channels == 1) {
            final gray = 0.299 * r + 0.587 * g + 0.114 * b;
            return [_normalize(gray)];
          }

          return [_normalize(r), _normalize(g), _normalize(b)];
        });
      }),
    ];
  }

  double _normalize(double value) => (value - 127.5) / 127.5;

  List<double> _softmax(List<double> values) {
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final exps = values.map((value) => _expApprox(value - maxValue)).toList();
    final sum = exps.fold<double>(0, (total, value) => total + value);
    return exps.map((value) => value / sum).toList();
  }

  // Aproximación estable suficiente para convertir logits pequeños en
  // probabilidades sin añadir otra dependencia matemática.
  double _expApprox(double x) {
    if (x < -20) return 0;
    if (x > 20) x = 20;

    var term = 1.0;
    var result = 1.0;
    for (var i = 1; i <= 24; i++) {
      term *= x / i;
      result += term;
    }
    return result < 0 ? 0 : result;
  }

  @override
  Future<void> dispose() async {
    _interpreter?.close();
    _interpreter = null;
  }
}
