import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:global_reparaturservice/utils/globals.dart';

class CustomMenuScreenAppBar extends StatelessWidget {
  const CustomMenuScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth * 100,
      height: 90,
      child: Column(
        children: [
          const SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      'Welcome,',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    AutoSizeText(
                      'Ahmed Albasha',
                      style:  TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Image.asset('assets/images/logo.png' , height: 40,)
              ],
            ),
          ),
          const SizedBox(height: 5,),
          Image.asset('assets/images/bottom_bar_curve.png' ,)
        ],
      ),
    );
  }
}
