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
        model: FakeEmotionModel([0.82, 0.08, 0.03, 0.04, 0.03]),
      );

      final result = service.resultFromScores([0.82, 0.08, 0.03, 0.04, 0.03]);

      expect(result.emotion, EmotionType.happy);
      expect(result.confidence, 0.82);
    });

    test('devuelve unknown bajo el umbral', () {
      final service = EmotionService(
        model: FakeEmotionModel([0.35, 0.30, 0.15, 0.10, 0.10]),
        confidenceThreshold: 0.60,
      );

      final result = service.resultFromScores([0.35, 0.30, 0.15, 0.10, 0.10]);

      expect(result.emotion, EmotionType.unknown);
      expect(result.confidence, inInclusiveRange(0, 1));
    });
  });
}
