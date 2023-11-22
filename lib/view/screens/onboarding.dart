import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/globals.dart';
import '../widgets/custom_button.dart';
import 'sign_in.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: SizedBox(
            width: screenWidth * 100,
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 67.5,
                  width: screenWidth * 100,
                  child: Image.asset(
                    'assets/images/on_boarding_image.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              'professional'.tr(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            AutoSizeText(
                              'inexpensive'.tr(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            AutoSizeText(
                              'fast_repair_service'.tr(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 90,
                        child: CustomButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignIn()));
                          },
                          text: 'sign_in'.tr(),
                          bgColor: Colors.white,
                          textColor: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
