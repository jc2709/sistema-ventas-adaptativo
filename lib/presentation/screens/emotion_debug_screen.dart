import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../processing/emotion/emotion_result.dart';
import '../../processing/emotion/emotion_service.dart';
import '../../processing/emotion/emotion_type.dart';
import '../../processing/emotion/tflite_emotion_model.dart';

class EmotionDebugScreen extends StatefulWidget {
  const EmotionDebugScreen({super.key});

  @override
  State<EmotionDebugScreen> createState() => _EmotionDebugScreenState();
}

class _EmotionDebugScreenState extends State<EmotionDebugScreen> {
  final _picker = ImagePicker();
  late final EmotionService _service;

  Uint8List? _imageBytes;
  EmotionResult? _result;
  String? _error;
  bool _loadingModel = true;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _service = EmotionService(model: TfliteEmotionModel());
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      await _service.load();
    } catch (error) {
      _error = 'No se pudo cargar el modelo: $error';
    } finally {
      if (mounted) {
        setState(() => _loadingModel = false);
      }
    }
  }

  Future<void> _selectImage(ImageSource source) async {
    if (_loadingModel || _error != null) return;

    final image = await _picker.pickImage(
      source: source,
      imageQuality: 90,
      preferredCameraDevice: CameraDevice.front,
    );
    if (image == null) return;

    final bytes = await image.readAsBytes();
    setState(() {
      _processing = true;
      _imageBytes = bytes;
      _result = null;
      _error = null;
    });

    try {
      final result = await _service.detectEmotion(bytes);
      if (mounted) setState(() => _result = result);
    } catch (error) {
      if (mounted) setState(() => _error = 'Error de inferencia: $error');
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba del detector de emociones')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: _imageBytes == null
                      ? const Center(
                          child: Text(
                            'Toma una foto o elige una imagen para analizarla.',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Image.memory(_imageBytes!, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 16),
              if (_loadingModel)
                const LinearProgressIndicator()
              else if (_processing)
                const LinearProgressIndicator(),
              if (_result != null) ...[
                const SizedBox(height: 12),
                Text(
                  _result!.emotion.displayName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'Confianza: ${(_result!.confidence * 100).toStringAsFixed(1)}%',
                  textAlign: TextAlign.center,
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _loadingModel || _processing || _error != null
                          ? null
                          : () => _selectImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Cámara'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _loadingModel || _processing || _error != null
                          ? null
                          : () => _selectImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Galería'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
