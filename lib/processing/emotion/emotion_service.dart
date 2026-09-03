import 'dart:typed_data';

import 'emotion_model.dart';
import 'emotion_result.dart';
import 'emotion_type.dart';
import 'image_preprocessor.dart';

/// API principal del módulo de PROCESAMIENTO de emociones.
class EmotionService {
  EmotionService({
    required this.model,
    this.preprocessor = const ImagePreprocessor(),
    this.confidenceThreshold = 0.60,
  }) : assert(confidenceThreshold >= 0 && confidenceThreshold <= 1);

  static const labels = <EmotionType>[
    EmotionType.happy,
    EmotionType.neutral,
    EmotionType.sad,
    EmotionType.angry,
    EmotionType.surprise,
  ];

  final EmotionModel model;
  final ImagePreprocessor preprocessor;
  final double confidenceThreshold;

  Future<EmotionResult> detectEmotion(Uint8List faceBytes) async {
    final prepared = preprocessor.prepare(faceBytes);
    final scores = await model.predict(prepared);
    return resultFromScores(scores);
  }

  EmotionResult resultFromScores(List<double> scores) {
    if (scores.length != labels.length) {
      throw ArgumentError(
        'Se esperaban ${labels.length} probabilidades y llegaron ${scores.length}.',
      );
    }

    var bestIndex = 0;
    var bestScore = scores.first;

    for (var i = 0; i < scores.length; i++) {
      final score = scores[i];
      if (!score.isFinite || score < 0 || score > 1) {
        throw ArgumentError('Las probabilidades deben estar entre 0 y 1.');
      }
      if (score > bestScore) {
        bestScore = score;
        bestIndex = i;
      }
    }

    if (bestScore < confidenceThreshold) {
      return EmotionResult(
        emotion: EmotionType.unknown,
        confidence: bestScore,
      );
    }

    return EmotionResult(
      emotion: labels[bestIndex],
      confidence: bestScore,
    );
  }
}
