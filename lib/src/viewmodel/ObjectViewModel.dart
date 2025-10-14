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

  // 📌 Detection output
  String _detectionResult = "";
  String get detectionResult => _detectionResult;

  // 📌 Proximity + Distance Info
  String _proximityInfo = "Unknown"; // e.g. Near, Far, Very Close
  String get proximityInfo => _proximityInfo;

  String _distanceInfo = "N/A"; // e.g. 1.5 meters
  String get distanceInfo => _distanceInfo;

  // 📌 Track near detection
  bool _nearDetection = false;

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

          // ✅ Update proximity info first
          _updateExtraInfo();

          // ✅ Prepare payload
          final Map<String, dynamic> payload = {
            "image": base64Image,
          };

          if (_nearDetection) {
            payload["nearDetection"] = true;
          }

          final response = await http.post(
            Uri.parse("https://sea-lion-app-buwxm.ondigitalocean.app/detect"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(payload),
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

  // 📌 Placeholder logic for proximity + distance
  void _updateExtraInfo() {
final randomDistance = (1 + (DateTime.now().second % 5)) * 0.25; // 0.25m to 1.25m

    _distanceInfo = "${randomDistance.toStringAsFixed(1)} meters";

    if (randomDistance < 1) {
      _proximityInfo = "Very Close";
      _nearDetection = true; // ✅ Trigger flag
    } else if (randomDistance < 2) {
      _proximityInfo = "Near";
      _nearDetection = false;
    } else {
      _proximityInfo = "Far";
      _nearDetection = false;
    }
  }

  void submitFeedback(BuildContext context) {
    if (feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your feedback before submitting.')),
      );
      return;
    }
    submitReport().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback submitted successfully!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit feedback: $error')),
      );
    });
  }
}
