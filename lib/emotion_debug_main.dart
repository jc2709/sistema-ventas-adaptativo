import 'package:flutter/material.dart';

import 'presentation/screens/emotion_debug_screen.dart';

void main() {
  runApp(const EmotionDebugApp());
}

class EmotionDebugApp extends StatelessWidget {
  const EmotionDebugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EmotionDebugScreen(),
    );
  }
}
