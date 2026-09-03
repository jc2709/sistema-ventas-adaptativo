import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:sistema_ventas_adaptativo/processing/emotion/emotion_model.dart';
import 'package:sistema_ventas_adaptativo/processing/emotion/emotion_service.dart';
import 'package:sistema_ventas_adaptativo/processing/emotion/emotion_type.dart';

class FakeEmotionModel implements EmotionModel {
  FakeEmotionModel(this.scores);

  final List<double> scores;

  @override
  Future<void> load() async {}

  @override
  Future<List<double>> predict(Uint8List preparedImage) async => scores;

  @override
  Future<void> dispose() async {}
}

void main() {
  group('EmotionService', () {
    test('selecciona la emoción con mayor confianza', () {
      final service = EmotionService(
        model: FakeEmotionModel([0.82, 0.03, 0.02, 0.02, 0.04, 0.02, 0.05]),
      );

      final result = service.resultFromScores(
        [0.82, 0.03, 0.02, 0.02, 0.04, 0.02, 0.05],
      );

      expect(result.emotion, EmotionType.happy);
      expect(result.confidence, 0.82);
    });

    test('respeta el orden de etiquetas del modelo', () {
      final service = EmotionService(
        model: FakeEmotionModel([0.02, 0.03, 0.05, 0.06, 0.72, 0.04, 0.08]),
      );

      final result = service.resultFromScores(
        [0.02, 0.03, 0.05, 0.06, 0.72, 0.04, 0.08],
      );

      expect(result.emotion, EmotionType.angry);
    });

    test('devuelve unknown bajo el umbral', () {
      final service = EmotionService(
        model: FakeEmotionModel([0.20, 0.15, 0.10, 0.10, 0.15, 0.10, 0.20]),
        confidenceThreshold: 0.45,
      );

      final result = service.resultFromScores(
        [0.20, 0.15, 0.10, 0.10, 0.15, 0.10, 0.20],
      );

      expect(result.emotion, EmotionType.unknown);
      expect(result.confidence, inInclusiveRange(0, 1));
    });

    test('rechaza una cantidad incorrecta de probabilidades', () {
      final service = EmotionService(
        model: FakeEmotionModel([0.5, 0.5]),
      );

      expect(
        () => service.resultFromScores([0.5, 0.5]),
        throwsArgumentError,
      );
    });

    test('rechaza probabilidades fuera del rango 0 a 1', () {
      final service = EmotionService(
        model: FakeEmotionModel([1.2, 0, 0, 0, 0, 0, 0]),
      );

      expect(
        () => service.resultFromScores([1.2, 0, 0, 0, 0, 0, 0]),
        throwsArgumentError,
      );
    });
  });
}
