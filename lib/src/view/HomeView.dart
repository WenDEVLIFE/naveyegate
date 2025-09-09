import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:naveyegate/src/helpers/ColorHelper.dart';
import 'package:naveyegate/src/viewmodel/ObjectViewModel.dart';
import 'package:naveyegate/src/widget/CustomText.dart';
import 'package:naveyegate/src/widget/CustomTextField.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final double boxSize = 250;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ObjectViewModel>(context, listen: false).initializeCamera();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: boxSize).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    Provider.of<ObjectViewModel>(context, listen: false).stopDetection(); // 🛑 Stop detection here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer<ObjectViewModel>(
      builder: (context, objectViewModel, child) {
        controller.text = objectViewModel.detectionResult; // keep updated on change
        return Scaffold(
          appBar: AppBar(
            title: CustomText(
              text: 'Home',
              fontFamily: 'EB Gammond',
              fontSize: 30,
              color: ColorHelper.primaryContainer,
              fontWeight: FontWeight.w700,
            ),
            backgroundColor: ColorHelper.primaryColor,
          ),
          body: objectViewModel.isInitialized && objectViewModel.cameraController != null
              ? Stack(
            children: [
              // 📷 Camera Preview
              SizedBox.expand(
                child: CameraPreview(objectViewModel.cameraController!),
              ),

              // 🔲 Detection Box
              Center(
                child: SizedBox(
                  width: boxSize,
                  height: boxSize,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.greenAccent, width: 3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Positioned(
                            top: _animation.value,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.greenAccent.withOpacity(0.8),
                                    Colors.greenAccent,
                                    Colors.greenAccent.withOpacity(0.8),
                                    Colors.transparent,
                                  ],
                                  stops: [0.0, 0.2, 0.5, 0.8, 1.0],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // 📝 Bottom Info Section
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🎤 Mic Button
                      IconButton(
                        icon: Icon(Icons.mic, color: Colors.white, size: 60),
                        onPressed: () {
                          objectViewModel.intializeTextToSpeech(objectViewModel.detectionResult);
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomText(
                        text: 'Press the mic to speak',
                        fontFamily: 'EB Gammond',
                        fontSize: 20,
                        color: ColorHelper.primaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(height: 8),

                      // 📦 Detected Object Text
                      SizedBox(
                        width: screenWidth * 0.8,
                        child: CustomTextField(
                          hintText: 'Scanned',
                          controller: controller,
                          keyboardType: TextInputType.text,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ➕ NEW: Extra Info Output
                      Card(
                        color: Colors.black.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              CustomText(
                                text: "Additional Info",
                                fontFamily: 'EB Gammond',
                                fontSize: 18,
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(height: 8),
                              CustomText(
                                text: "Proximity: ${objectViewModel.proximityInfo}", // 🔊 from ViewModel
                                fontFamily: 'EB Gammond',
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(height: 4),
                              CustomText(
                                text: "Estimated Distance: ${objectViewModel.distanceInfo}", // 📏 placeholder
                                fontFamily: 'EB Gammond',
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
