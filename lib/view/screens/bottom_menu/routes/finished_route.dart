import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/core/globals.dart';
import 'package:global_reparaturservice/core/providers/user_provider.dart';
import 'package:global_reparaturservice/view/screens/home.dart';
import 'package:global_reparaturservice/view/widgets/custom_button.dart';
import 'package:lottie/lottie.dart';

class FinishedRouteScreen extends ConsumerWidget {
  const FinishedRouteScreen({super.key});

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: SizedBox(
            width: screenWidth * 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Lottie.asset(
                  'assets/images/finished_animation.json',
                  height: 200
                ),

                AutoSizeText(
                    '${'congrats'.tr()} ${ref.read(userProvider)?.name} !! \n${'your_route_successfully_finished'.tr()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(
                  height: 50,
                  width: screenWidth * 85,
                  child: CustomButton(
                    onPressed: (){
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          Home()), (Route<dynamic> route) => false);
                    },
                    text: 'go_to_routes_screen'.tr(),
                    textColor: Theme.of(context).primaryColor,
                    bgColor: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
