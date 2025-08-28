import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naveyegate/src/helpers/ColorHelper.dart';

class CustomPasswordField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;

  const CustomPasswordField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.keyboardType,
    required this.obscureText,
  });

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        CupertinoTextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          placeholder: widget.hintText,
          cursorColor: ColorHelper.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: ColorHelper.primaryContainer,
            borderRadius: BorderRadius.circular(8.0),
          ),
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'EB Garamond',
            fontWeight: FontWeight.w700,
            color: ColorHelper.primaryColor,
          ),
          obscureText: _obscureText,
        ),
        IconButton(
          icon: Icon(
            _obscureText ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
            color: ColorHelper.primaryColor,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ],
    );
  }
}