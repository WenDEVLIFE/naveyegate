import 'package:flutter/cupertino.dart';
import 'package:naveyegate/src/helpers/ColorHelper.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      keyboardType: keyboardType,
      placeholder: hintText,
       cursorColor: ColorHelper.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: ColorHelper.primaryContainer,
        borderRadius: BorderRadius.circular(8.0),
      ),
      style: TextStyle(
        fontSize: 16.0,
        color: ColorHelper.primaryColor,
      ),
    );
  }

}