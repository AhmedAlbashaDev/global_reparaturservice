import 'package:flutter/material.dart';

import '../../core/globals.dart';


class SignInTopView extends StatelessWidget {
  const SignInTopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: screenHeight * 25,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Image.asset('assets/images/logo.png' , height: screenHeight * 17,color: Colors.white,),
          ),
        ),

        Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: screenHeight * 23,
                ),
                Stack(
                  children: [
                    Image.asset('assets/images/white_curve.png' , height: screenHeight * 7,),
                    Column(
                      children: [
                        SizedBox(height: screenHeight * 3,),
                        Image.asset('assets/images/blue_curve.png'),
                      ],
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}
