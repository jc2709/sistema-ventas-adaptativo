enum EmotionType {
  happy,
  sad,
  surprise,
  fear,
  angry,
  disgust,
  neutral,
  unknown,
}

extension EmotionTypeLabel on EmotionType {
  String get displayName => switch (this) {
        EmotionType.happy => 'Feliz',
        EmotionType.sad => 'Triste',
        EmotionType.surprise => 'Sorprendido',
        EmotionType.fear => 'Miedo',
        EmotionType.angry => 'Enojado',
        EmotionType.disgust => 'Disgusto',
        EmotionType.neutral => 'Neutral',
        EmotionType.unknown => 'Desconocido',
      };
}
