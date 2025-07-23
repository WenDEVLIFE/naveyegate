import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/ColorHelper.dart';
import '../widget/CustomText.dart';

class FeedBackView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Feedback',
          fontFamily: 'EB Gammond',
          fontSize: 30,
          color: ColorHelper.primaryContainer,
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: ColorHelper.primaryColor,
      ),
      body: Center(
        child: Text(
          'Feedback Form',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }

}