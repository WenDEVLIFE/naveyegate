import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naveyegate/src/helpers/ColorHelper.dart';
import 'package:naveyegate/src/widget/CustomText.dart';
import 'package:naveyegate/src/widget/CustomTextField.dart';
import 'package:provider/provider.dart';

import '../viewmodel/ObjectViewModel.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final double boxSize = 250;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ObjectViewModel>(context, listen: false).initializeCamera();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: boxSize).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Consumer<ObjectViewModel>(
      builder: (context, objectViewModel, child) {
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
              SizedBox.expand(
                child: CameraPreview(objectViewModel.cameraController!),
              ),
              // Scanning box overlay with animated line
              Center(
                child: SizedBox(
                  width: boxSize,
                  height: boxSize,
                  child: Stack(
                    children: [
                      Container(
                        width: boxSize,
                        height: boxSize,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.greenAccent, width: 3),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.greenAccent.withOpacity(0.3),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
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
                              width: boxSize,
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
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.greenAccent.withOpacity(0.7),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Semi-transparent mask
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: Colors.black.withAlpha(102),
                    child: Center(
                      child: Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Bottom content
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.mic, color: Colors.white, size: 60),
                        onPressed: () {
                          // Handle mic action
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
                      SizedBox(
                        width: screenWidth * 0.8,
                        child: CustomTextField(
                          hintText: 'Output',
                          controller: controller,
                          keyboardType: TextInputType.text,
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