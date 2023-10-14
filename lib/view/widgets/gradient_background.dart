import 'package:flutter/material.dart';

import '../../core/globals.dart';

class GradientBackgroundWidget extends StatelessWidget {
  const GradientBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 80,),
        Expanded(
          child: Image.asset(
            'assets/images/gradient_background.png',
            width: screenWidth * 100,
            height: screenHeight * 100,
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }
}
