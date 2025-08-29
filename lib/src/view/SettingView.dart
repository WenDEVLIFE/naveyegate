import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naveyegate/src/helpers/SessionHelpers.dart';
import 'package:naveyegate/src/view/LoginView.dart';

import '../helpers/ColorHelper.dart';
import '../widget/CustomButton.dart';
import '../widget/CustomText.dart';

class SettingView extends StatefulWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  double _volume = 0.5;
  double _gestureSensitivity = 0.5;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Settings',
          fontFamily: 'EB Garamond',
          fontSize: 30,
          color: ColorHelper.primaryContainer,
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: ColorHelper.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Language',
              fontFamily: 'EB Garamond',
              fontSize: 22,
              color: ColorHelper.primaryColor,
              fontWeight: FontWeight.w600,
            ),
            DropdownButton<String>(
              value: _selectedLanguage,
              items: <String>['English', 'Tagalog']
                  .map((String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value,
                    style: TextStyle(
                        fontFamily: 'EB Garamond',
                        fontSize: 18,
                        color: ColorHelper.primaryColor)),
              ))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                });
              },
            ),
            SizedBox(height: 24),
            CustomText(
              text: 'Volume',
              fontFamily: 'EB Garamond',
              fontSize: 22,
              color: ColorHelper.primaryColor,
              fontWeight: FontWeight.w600,
            ),
            Slider(
              value: _volume,
              min: 0,
              max: 1,
              divisions: 10,
              label: (_volume * 100).toInt().toString(),
              activeColor: ColorHelper.primaryColor,
              onChanged: (value) {
                setState(() {
                  _volume = value;
                });
              },
            ),
            CustomText(
              text: 'Gesture Sensitivity',
              fontFamily: 'EB Garamond',
              fontSize: 22,
              color: ColorHelper.primaryColor,
              fontWeight: FontWeight.w600,
            ),
            Slider(
              value: _gestureSensitivity,
              min: 0,
              max: 1,
              divisions: 10,
              label: (_gestureSensitivity * 100).toInt().toString(),
              activeColor: ColorHelper.secondaryColor,
              onChanged: (value) {
                setState(() {
                  _gestureSensitivity = value;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: SizedBox(
                width: screenWidth * 0.9,
                height: screenHeight * 0.06,
                child: CustomButton(
                  hintText: 'Logout',
                  onPressed: () {
                      SessionHelpers sessionHelpers = SessionHelpers();
                      sessionHelpers.clearUserInfo();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                        return const LoginView();
                      }));
                  },
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}