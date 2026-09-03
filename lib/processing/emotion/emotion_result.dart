import 'emotion_type.dart';

class EmotionResult {
  const EmotionResult({required this.emotion, required this.confidence});

  final EmotionType emotion;
  final double confidence;
}
