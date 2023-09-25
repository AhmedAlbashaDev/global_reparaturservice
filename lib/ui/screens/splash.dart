import 'package:flutter/material.dart';
import 'package:global_reparaturservice/ui/screens/onboarding.dart';
import 'package:global_reparaturservice/utils/globals.dart';
import '../widgets/version_widget.dart';

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
    Future.microtask(() =>
      const Duration(seconds: 2),
    ).then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnBoarding())));
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
            Image.asset('assets/images/titled_logo.png' , height: screenHeight * 24,),
            const VersionWidget()
          ],
        ),
      ),
    );
  }
}
