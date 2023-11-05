import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../core/globals.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.onPop,
  });

  final String title;
  final VoidCallback? onPop;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth * 100,
      height: 90,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: onPop ?? (){
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded , size: 30,),
                  ),
                  AutoSizeText(
                    title,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                    height: 40,
                  )
                ],
              ),
            ),
          ),
          Image.asset(
            'assets/images/bottom_bar_curve.png',
          )
        ],
      ),
    );
  }
}
