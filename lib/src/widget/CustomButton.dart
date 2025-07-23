import 'package:flutter/cupertino.dart';
import 'package:naveyegate/src/helpers/ColorHelper.dart';

class CustomButton extends StatelessWidget {

  final String hintText;

  final VoidCallback onPressed;

  CustomButton({
    super.key,
    required this.hintText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        onPressed: onPressed,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        borderRadius: BorderRadius.circular(8),
        color: ColorHelper.primaryColor,
        child: Text(
          hintText,
          style: TextStyle(
            fontSize: 25,
            fontFamily:'EB Garamond',
            fontWeight: FontWeight.w700,
            color: ColorHelper.primaryContainer,
          ),
        )
    );
  }
}