import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naveyegate/src/helpers/ColorHelper.dart';
import 'package:naveyegate/src/widget/CustomText.dart';
import 'package:provider/provider.dart';

import '../viewmodel/ObjectViewModel.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

   HomeViewState createState() => HomeViewState();


}

class HomeViewState extends State<HomeView> {

  @override
  Widget build(BuildContext context) {
    return Consumer<ObjectViewModel>(
      builder: (context, objectViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: CustomText(text: 'Home', fontFamily: 'EB Gammond', fontSize: 30, color: ColorHelper.primaryContainer, fontWeight: FontWeight.w700),
            backgroundColor: ColorHelper.primaryColor,
          ),
          body: Center(
            child: Text(
              'Welcome to Home View',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
          ),

        );
      },
    );
  }
}