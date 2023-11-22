import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onPressed, required this.text, required this.textColor, required this.bgColor , this.icon , this.radius = 10 , this.height = 55});

  final VoidCallback? onPressed;
  final String? text;
  final Color textColor;
  final Color bgColor;
  final Icon? icon;
  final double radius;
  final double height;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: bgColor,
      disabledColor: Colors.grey.shade500,
      height: height,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius)
      ),
      child:  Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? const SizedBox(),
            SizedBox(width: icon != null ? 5 : 0,),
            Expanded(
              child: AutoSizeText(
                text ?? '',
                style:  TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 17
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
