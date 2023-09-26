import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../utils/globals.dart';
import '../widgets/version_widget.dart';
import 'onboarding.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 4)).then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnBoarding())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Image.asset(
              'assets/images/titled_logo.png',
              fit: BoxFit.contain,
              height: screenHeight * 20,
            ),
            Column(
              children: [
                Lottie.asset(
                    'assets/images/global_loader.json',
                    height: 50
                ),
                const VersionWidget(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
