import 'package:flutter/material.dart';
import 'package:naveyegate/src/helpers/ColorHelper.dart';
import 'package:naveyegate/src/widget/CustomText.dart';
import 'package:provider/provider.dart';

import '../viewmodel/ObjectViewModel.dart';

class DropDownText extends StatelessWidget {
  final String title;
  final String description;

  const DropDownText({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: ColorHelper.primaryContainer,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
       child:  ExpansionTile(
         backgroundColor: ColorHelper.primaryContainer,
         collapsedBackgroundColor: ColorHelper.primaryContainer, // Set your collapsed color here
         iconColor: ColorHelper.primaryColor,
         collapsedIconColor: ColorHelper.primaryColor,
         title: Text(
           title,
           style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
         ),
         children: [
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
             child: Text(
               description,
               style: TextStyle(fontSize: 18, color: Colors.black45, fontFamily: 'EB Gammond', fontWeight: FontWeight.w500),
             ),
           ),
           GestureDetector(
             onTap: () {
               // Add your action here
               Provider.of<ObjectViewModel>(context, listen: false).intializeTextToSpeech(description);
             },
             child: Center(
               child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   CustomText(text: 'Click me to speak', fontFamily: 'EB Gammond', fontSize: 20, color: ColorHelper.secondaryColor, fontWeight: FontWeight.w700),
                   SizedBox(width: screenWidth * 0.02),
                   Icon(
                     Icons.record_voice_over_rounded,
                     color: ColorHelper.primaryColor,
                   ),
                 ],
               ),
             )
           )
         ],
       ),
    );
  }
}