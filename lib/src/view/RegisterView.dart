import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:naveyegate/src/repository/RegisterRepository.dart';
import 'package:naveyegate/src/services/EmailSenderService.dart';

import '../helpers/ColorHelper.dart';
import '../widget/CustomButton.dart';
import '../widget/CustomPasswordField.dart';
import '../widget/CustomText.dart';
import '../widget/CustomTextField.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool obscureText = true;

  Future <String> generateOTP() async {
    // Generate a random 6-digit OTP
    final otp = (100000 + (999999 - 100000) * (new DateTime.now().millisecondsSinceEpoch % 1000) / 1000).toInt();
    return otp.toString();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      backgroundColor: ColorHelper.primaryColor,
      body: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(
                left: screenWidth * 0.05, top: screenHeight * 0.1),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  text: 'Register',
                  fontFamily: 'EB Garamond',
                  fontSize: 30,
                  color: ColorHelper.primaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(
                left: screenWidth * 0.05, top: screenHeight * 0.02),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  text: 'Please create an account',
                  fontFamily: 'EB Garamond',
                  fontSize: 20,
                  color: ColorHelper.primaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: screenWidth * 0.9,
                height: screenHeight * 0.05,
                child: CustomTextField(
                    hintText: 'Email',
                    controller: emailController,
                    keyboardType: TextInputType.text),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.05,
                  child: CustomPasswordField(
                      hintText: 'Password',
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: obscureText
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.05,
                  child: CustomPasswordField(
                      hintText: 'Confirm Password',
                      controller: confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: obscureText
                  )
              ),
            ),

            SizedBox(height: screenHeight * 0.05,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: screenWidth * 0.9,
                height: screenHeight * 0.06,
                child: CustomButton(hintText: 'Register', onPressed: () async {
                   if (emailController.text.isEmpty || passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "Please fill all the fields",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    return;
                  }
                   if(emailController.text.contains('@') == false){
                     Fluttertoast.showToast(
                       msg: "Please enter a valid email",
                       toastLength: Toast.LENGTH_SHORT,
                       gravity: ToastGravity.BOTTOM,
                       timeInSecForIosWeb: 1,
                       backgroundColor: Colors.grey,
                       textColor: Colors.white,
                       fontSize: 16.0,
                     );
                     return;
                   }

                    if (passwordController.text != confirmPasswordController.text) {
                      Fluttertoast.showToast(
                        msg: "Passwords do not match",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      return;
                    }

                   String otp = await generateOTP();
                   EmailSenderService.sendEmail(emailController.text, otp);
                   openOTPDialog(emailController.text, passwordController.text, otp);
                }),
              ),
            ),
            Padding(padding: EdgeInsets.only(
                left: screenWidth * 0.05, top: screenHeight * 0.02),
              child: Align(
                alignment: Alignment.center,
                child: CustomText(
                  text: 'Already have an account? Login here',
                  fontFamily: 'EB Garamond',
                  fontSize: 20,
                  color: ColorHelper.primaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: screenWidth * 0.9,
                height: screenHeight * 0.06,
                child: CustomButton(hintText: 'Login', onPressed: () {
                  Navigator.pop(context);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // opne the dialog to enter the OTP
  void openOTPDialog(String email, String password, String otp) {
    final RegisterRepositoryImpl registerRepository = RegisterRepositoryImpl();
     final TextEditingController otpController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int secondsLeft = 30;
        Timer? timer;

        return StatefulBuilder(
          builder: (context, setState) {
            timer ??= Timer.periodic(Duration(seconds: 1), (t) {
                if (secondsLeft > 0) {
                  setState(() {
                    secondsLeft--;
                  });
                } else {
                  t.cancel();
                }
              });

            final double screenHeight = MediaQuery.of(context).size.height;
            final double screenWidth = MediaQuery.of(context).size.width;

            return AlertDialog(
              backgroundColor: ColorHelper.primaryColor,
              title: CustomText(
                text: 'Enter the OTP sent to your email',
                fontFamily: 'EB Garamond',
                fontSize: 20,
                color: ColorHelper.primaryContainer,
                fontWeight: FontWeight.w700,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text:  'Time left: $secondsLeft seconds',
                    fontFamily: 'EB Garamond',
                    fontSize: 20,
                    color: ColorHelper.primaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.05,
                      child:  CustomTextField(
                          hintText: 'Verification code',
                          controller: otpController,
                          keyboardType: TextInputType.text),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[

                TextButton(
                  child:CustomText(
                    text: 'Cancel',
                    fontFamily: 'EB Garamond',
                    fontSize: 20,
                    color: ColorHelper.primaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                  onPressed: () {
                    timer?.cancel();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child:CustomText(
                    text: 'Resend',
                    fontFamily: 'EB Garamond',
                    fontSize: 20,
                    color: ColorHelper.primaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                  onPressed: () {
                    if (secondsLeft == 0) {
                      setState(() {
                        secondsLeft = 30;
                      });
                      Fluttertoast.showToast(
                        msg: "OTP resent",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                    Fluttertoast.showToast(
                      msg: "Please wait for the timer to finish",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                ),
                TextButton(
                  onPressed: secondsLeft == 0
                      ? null
                      : () async {

                    if (otpController.text == otp) {
                      timer?.cancel();
                      await registerRepository.registerUser(email, password);
                      Navigator.of(context).pop();
                      Navigator.pop(context);
                    } else {
                      Fluttertoast.showToast(
                        msg: "Invalid OTP",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  child: CustomText(
                    text: 'Submit',
                    fontFamily: 'EB Garamond',
                    fontSize: 20,
                    color: ColorHelper.primaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}