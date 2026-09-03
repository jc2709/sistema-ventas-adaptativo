import '../../processing/emotion/emotion_result.dart';
import 'adaptation_rule.dart';

/// Contrato de la etapa de DECISIÓN.
abstract interface class AdaptationEngine {
  AdaptationDecision decide(EmotionResult emotionResult);
}
