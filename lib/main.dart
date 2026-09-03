import 'package:flutter/material.dart';

void main() {
  runApp(const AdaptiveSalesApp());
}

class AdaptiveSalesApp extends StatelessWidget {
  const AdaptiveSalesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Ventas Adaptativo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Sistema de Ventas Adaptativo')),
        body: const Center(
          child: Text('Arquitectura base lista para desarrollar'),
        ),
      ),
    );
  }
}
