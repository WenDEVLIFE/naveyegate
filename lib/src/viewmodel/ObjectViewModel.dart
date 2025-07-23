import 'dart:ffi';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class ObjectViewModel extends ChangeNotifier {

  CameraController? cameraController;
  bool isInitialized = false;
  Uint8  ? imageBytes;



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
  }



}