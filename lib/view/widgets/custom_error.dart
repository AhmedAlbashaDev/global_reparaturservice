import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:global_reparaturservice/core/globals.dart';
import 'package:global_reparaturservice/view/widgets/custom_button.dart';

class CustomError extends StatelessWidget {
  const CustomError({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: AutoSizeText(
                message,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
                width: screenWidth * 80,
                child: CustomButton(
                  onPressed: onRetry,
                  text: 'Retry',
                  textColor: Colors.white,
                  bgColor: Colors.red.shade400,
                ))
          ],
        ),
      ),
    );
  }
}
