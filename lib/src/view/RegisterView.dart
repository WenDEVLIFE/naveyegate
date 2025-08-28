import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  TextEditingController feedbackController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
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
                    hintText: 'Username',
                    controller: feedbackController,
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
                      controller: passwordController,
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
                child: CustomButton(hintText: 'Register', onPressed: () {

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
}