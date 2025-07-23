import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/ColorHelper.dart';
import '../widget/CustomText.dart';
import '../widget/DropDownText.dart';

class TutorialView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Tutorial',
          fontFamily: 'EB Garamond',
          fontSize: 30,
          color: ColorHelper.primaryContainer,
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: ColorHelper.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropDownText(
                title: 'How to use the app',
                description: 'This app helps you navigate through various features and functionalities. Follow the steps below to get started.',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropDownText(
                title: 'How to use the app',
                description: 'This app helps you navigate through various features and functionalities. Follow the steps below to get started.',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropDownText(
                title: 'How to use the app',
                description: 'This app helps you navigate through various features and functionalities. Follow the steps below to get started.',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropDownText(
                title: 'How to use the app',
                description: 'This app helps you navigate through various features and functionalities. Follow the steps below to get started.',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropDownText(
                title: 'How to use the app',
                description: 'This app helps you navigate through various features and functionalities. Follow the steps below to get started.',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropDownText(
                title: 'How to use the app',
                description: 'This app helps you navigate through various features and functionalities. Follow the steps below to get started.',
              ),
            ),

          ],
        ),
      ),
    );
  }
  
}