import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:naveyegate/src/repository/SubmitRepository.dart';

class ObjectViewModel extends ChangeNotifier {
  CameraController? cameraController;
  bool isInitialized = false;
  Uint8List? imageBytes;
  final TextEditingController feedbackController = TextEditingController();
  final SubmitRepositoryImpl submitRepository = SubmitRepositoryImpl();
  final FlutterTts _flutterTts = FlutterTts();

  bool _stopScanning = false;

  String _detectionResult = "";
  String get detectionResult => _detectionResult;

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    cameraController = CameraController(
      cameras.first,
      ResolutionPreset.medium,
    );
    await cameraController!.initialize();
    isInitialized = true;
    notifyListeners();

    // Start object detection loop
    startDetectionLoop();
  }

  @override
  void dispose() {
    _stopScanning = true;
    cameraController?.dispose();
    feedbackController.dispose();
    _flutterTts.stop();
    super.dispose();
  }
void stopDetection() {
  _stopScanning = true;
}
void restartDetection() {
  _stopScanning = false;
  startDetectionLoop();
}

  Future<void> intializeTextToSpeech(String description) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(description);
    print("Text to Speech: $description");
  }

  Future<void> submitReport() async {
    String feedback = feedbackController.text.trim();
    if (feedback.isNotEmpty) {
      print("Feedback submitted: $feedback");
      await submitRepository.submitReport(feedback: feedback);
      feedbackController.clear();
    } else {
      print("Feedback is empty, nothing to submit.");
    }
  }

  Future<void> startDetectionLoop() async {
    while (!_stopScanning) {
      try {
        if (cameraController != null && cameraController!.value.isInitialized) {
          final XFile imageFile = await cameraController!.takePicture();
          final bytes = await imageFile.readAsBytes();
          imageBytes = Uint8List.fromList(bytes);

          String base64Image = base64Encode(imageBytes!);

          final response = await http.post(
            Uri.parse("http://192.168.100.12:5000/detect"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"image": base64Image}),
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            final detections = data["detections"];

            if (detections == null || detections.isEmpty) {
              _detectionResult = "No object detected.";
              await intializeTextToSpeech(_detectionResult);
            } else {
              String result = detections.map((e) => e["class"]).join(", ");
              _detectionResult = "Detected: $result";
              await intializeTextToSpeech(_detectionResult);
            }
          } else {
            _detectionResult = "Error from server.";
            await intializeTextToSpeech(_detectionResult);
          }
        }
      } catch (e) {
        _detectionResult = "Something went wrong.";
        await intializeTextToSpeech(_detectionResult);
      }

      notifyListeners();
      await Future.delayed(const Duration(seconds: 5));
    }
  }
}
