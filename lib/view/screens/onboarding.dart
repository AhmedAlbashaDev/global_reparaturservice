import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
            child: Stack(
              children: [
                SizedBox(
                  width: screenWidth * 100,
                  child: Lottie.asset(
                    'assets/images/technician_animation.json',
                    fit: BoxFit.cover
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 45,
                    ),
                    Image.asset('assets/images/white_curve.png',),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/logo.png',
                                      color: Colors.white,
                                      height: 45,
                                    ),
                                     const SizedBox(width: 5,),
                                     AutoSizeText(
                                      'global'.tr(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      'professional'.tr(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    AutoSizeText(
                                      'inexpensive'.tr(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    AutoSizeText(
                                      'fast_repair_service'.tr(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: screenWidth * 90,
                            child: CustomButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignIn()));
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
                )
              ],
            ),
          ),
        ));
  }
}
