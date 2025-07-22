import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:naveyegate/src/view/MainView.dart';

import '../helpers/ColorHelper.dart';
import '../widget/CustomText.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setLoading();
  }

  Future<void> setLoading() async {
    await Future.delayed(const Duration(seconds: 3));
    Fluttertoast.showToast(
      msg: "Loading completed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    setState(() {
      isLoading = false;
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const MainView();
    }));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorHelper.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.2),
            CustomText(
              text: 'NAVEYEGATE',
              fontFamily: 'EB Garamond',
              fontSize: 30,
              color: ColorHelper.primaryContainer,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                ColorHelper.primaryContainer,
              ),
            )
                : const SizedBox.shrink(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}