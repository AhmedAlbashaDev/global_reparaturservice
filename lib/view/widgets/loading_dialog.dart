import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/globals.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 75,
        width: screenWidth * 80,
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
                'assets/images/global_loader.json',
                height: 50
            ),
          ],
        ),
      ),
    );
  }
}
