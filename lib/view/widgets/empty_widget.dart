import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:global_reparaturservice/core/globals.dart';
import 'package:lottie/lottie.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, required this.text , this.height = 50 , this.textSize = 17});

  final String text;
  final double height;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Lottie.asset('assets/images/empty_animation.json',fit: BoxFit.contain , height: screenHeight * 25),
        // SizedBox(height: height != 50 ? 10 : 20,),
        AutoSizeText(
          'no_data'.tr(),
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
