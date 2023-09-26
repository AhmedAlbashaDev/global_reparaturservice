import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onPressed, required this.text, required this.textColor, required this.bgColor});

  final VoidCallback onPressed;
  final String? text;
  final Color textColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: bgColor,
      height: 50,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25)
      ),
      child:  Center(
        child: AutoSizeText(
          text ?? '',
          style:  TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 17
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
