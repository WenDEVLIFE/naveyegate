import 'package:flutter/material.dart';
import 'package:naveyegate/src/repository/LoginRepository.dart';
import 'package:naveyegate/src/view/MainView.dart';
import 'package:naveyegate/src/widget/CustomButton.dart';
import 'package:naveyegate/src/widget/CustomPasswordField.dart';
import 'package:naveyegate/src/widget/CustomTextField.dart';

import '../helpers/ColorHelper.dart';
import '../widget/CustomText.dart';
import 'RegisterView.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginRepository _loginRepository = LoginRepositoryImpl();
  TextEditingController feedbackController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorHelper.primaryColor,
      body: Center(
        child: Column(
          children: [
             Padding(padding:   EdgeInsets.only(left:  screenWidth*0.05, top: screenHeight*0.1),
               child: Align(
                 alignment: Alignment.centerLeft,
                 child: CustomText(
                   text: 'Welcome Back',
                   fontFamily: 'EB Garamond',
                   fontSize: 30,
                   color: ColorHelper.primaryContainer,
                   fontWeight: FontWeight.w700,
                 ),
               ),
             ),
            Padding(padding:   EdgeInsets.only(left:  screenWidth*0.05, top: screenHeight*0.02),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  text: 'Please login to your account',
                  fontFamily: 'EB Garamond',
                  fontSize: 20,
                  color: ColorHelper.primaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: screenHeight*0.05,),
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
                    keyboardType:  TextInputType.visiblePassword,
                    obscureText:   obscureText
                )
              ),
            ),

            SizedBox(height: screenHeight*0.05,),
             Padding(
               padding: const EdgeInsets.all(16.0),
               child: SizedBox(
                 width: screenWidth * 0.9,
                 height: screenHeight * 0.06,
                 child: CustomButton(hintText: 'Login', onPressed: (){
                   String email = feedbackController.text.trim();
                    String password = passwordController.text.trim();

                    if (email.isEmpty || password.isEmpty) {
                      // Show error message if fields are empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter both email and password')),
                      );
                      return;
                    }

                    _loginRepository.loginUser(email, password).then((success) {
                      if (success) {
                        // Navigate to the next screen or show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Login Successful')),
                        );

                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                          return MainView();
                        }));
                      } else {
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Login Failed. Please check your credentials.')),
                        );
                      }
                    });
                 }),
               ),
             ),
            Padding(padding:   EdgeInsets.only(left:  screenWidth*0.05, top: screenHeight*0.02),
              child: Align(
                alignment: Alignment.center,
                child: CustomText(
                  text: 'Don\'t have an account? Register',
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
                child: CustomButton(hintText: 'Register', onPressed: (){

                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const RegisterView();
                  }));
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}