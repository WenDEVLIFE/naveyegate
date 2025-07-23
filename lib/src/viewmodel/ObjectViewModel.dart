import 'dart:ffi';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ObjectViewModel extends ChangeNotifier {

  CameraController? cameraController;
  bool isInitialized = false;
  Uint8  ? imageBytes;
  final TextEditingController feedbackController = TextEditingController();

  final FlutterTts _flutterTts = FlutterTts();

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
    );
    await cameraController!.initialize();
    isInitialized = true;
    notifyListeners();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
    _flutterTts.stop();
  }

  void intializeTextToSpeech(String description) async {
    await _flutterTts.speak(description);
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    print("Text to Speech initialized with description: $description");
    notifyListeners();
  }



}