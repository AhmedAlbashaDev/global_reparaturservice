import 'package:flutter/material.dart';

import '../../utils/globals.dart';

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
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
