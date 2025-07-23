import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/ColorHelper.dart';
import '../widget/CustomText.dart';

class SettingView extends StatelessWidget {

  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    );
  }
}