import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naveyegate/src/viewmodel/ObjectViewModel.dart';
import 'package:naveyegate/src/widget/CustomButton.dart';
import 'package:provider/provider.dart';

import '../helpers/ColorHelper.dart';
import '../widget/CustomText.dart';

class FeedBackView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Consumer<ObjectViewModel>(
      builder: (context, objectViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: CustomText(
              text: 'Feedback',
              fontFamily: 'EB Garamond',
              fontSize: 30,
              color: ColorHelper.primaryContainer,
              fontWeight: FontWeight.w700,
            ),
            backgroundColor: ColorHelper.primaryColor,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomText(
                      text: 'We value your feedback!',
                      fontFamily: 'EB Garamond',
                      fontSize: 25,
                      color: ColorHelper.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.5,
                      child: CupertinoTextField(
                        controller: objectViewModel.feedbackController,
                        placeholder: 'Your feedback here...',
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        cursorColor: ColorHelper.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          color: ColorHelper.primaryContainer,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        style: TextStyle(
                          fontSize: 30.0,
                          fontFamily: 'EB Gammond',
                          fontWeight: FontWeight.w700,
                          color: ColorHelper.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: SizedBox(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.06,
                      child: CustomButton(
                        hintText: 'Submit',
                        onPressed: () {

                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}