import 'package:flutter/cupertino.dart';

class CustomText extends StatelessWidget {
  final String text;

  final String fontFamily;

  final double fontSize;

  final Color color;

  final FontWeight fontWeight;


  const CustomText({
    super.key,
    required this.text,
    required this.fontFamily,
    required this.fontSize,
    required this.color,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}