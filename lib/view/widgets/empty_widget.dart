import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, required this.text , this.height = 50 , this.textSize = 17});

  final String text;
  final double height;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/empty_list.png' , height: height,),
        SizedBox(height: height != 50 ? 10 : 20,),
        AutoSizeText(
          text,
          style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor
          ),
        )
      ],
    );
  }
}
